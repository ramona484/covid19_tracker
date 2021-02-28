# build environment
FROM node:12.21.0-alpine3.10 as builder
LABEL version="1.0"


WORKDIR /app
COPY package*.json ./
RUN npm ci --production && npm cache clean --force
COPY . .
RUN npm run build

FROM nginx:1.18
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]