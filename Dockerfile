FROM node:lts-alpine3.10 AS builder
LABEL version="jane.doe@outlook.com"
WORKDIR /app
COPY package*.json ./

RUN npm ci --production
COPY . .
RUN npm run build

FROM nginx:1.19.5-alpine-perl AS production
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
