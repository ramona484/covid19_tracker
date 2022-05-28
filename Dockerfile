FROM node:latest AS builder
LABEL version="jane.doe@outlook.com"
WORKDIR app
ADD package*.json ./

RUN npm ci --production
ADD . .
RUN npm run build

FROM nginx:1.22 AS production
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


