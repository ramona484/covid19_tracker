# build environment
FROM node:14-buster as builder
LABEL version="1.0"


WORKDIR /app
COPY package*.json ./
RUN npm ci --production && npm cache clean --force
COPY . .
RUN npm run build

FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]