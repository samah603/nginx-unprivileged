FROM node:14.16-alpine AS builder

WORKDIR /app

ADD package.json /app/

RUN npm install

COPY . .

FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY --from=builder /app/dist/ /usr/share/nginx/html/

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /var/cache/nginx && chown -R nginx:nginx /var/cache/nginx && \
    mkdir -p /var/log/nginx  && chown -R nginx:nginx /var/log/nginx && \
    mkdir -p /var/lib/nginx  && chown -R nginx:nginx /var/lib/nginx && \
    touch /run/nginx.pid && chown -R nginx}:nginx} /run/nginx.pid && \
    mkdir -p /etc/nginx/templates /etc/nginx/ssl/certs && \
    chown -R nginx:nginx /etc/nginx && \
    chmod -R 777 /etc/nginx/conf.d

# disable nginx user cuz running as non-root
RUN sed -i 's/user nginx;/#user nginx;/g' /etc/nginx/nginx.conf

USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
