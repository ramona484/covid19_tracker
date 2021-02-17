# build environment
FROM node:latest as builder
RUN apt-get update
WORKDIR app
ADD package*.json ./

RUN npm ci --only=production
COPY . .
RUN npm run build


# production environment
FROM nginx:latest
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

