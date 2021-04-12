FROM node:lts-alpine3.13 AS builder
LABEL version="jane.doee@outlook.com"
WORKDIR /app
COPY package*.json ./

RUN npm ci --production
COPY . .
RUN npm run build

FROM nginx:1.19-alpine-perl AS production
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
