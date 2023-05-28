FROM node:current-alpine3.16 as build
WORKDIR /app
COPY ./build /app
FROM nginx:1.16.0-alpine
COPY --from=build /app /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
