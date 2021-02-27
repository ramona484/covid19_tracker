# build environment
FROM node:14.15-stretch as builder
LABEL version="1.0"

ENV ACCESS_KEY=AKUIS6VEP9M7KLD5UIO69

WORKDIR /app
COPY package*.json ./
RUN npm ci --production && npm cache clean --force
COPY . .
RUN npm run build

FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]