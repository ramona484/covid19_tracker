# build environment
FROM node:14.15-stretch as builder
LABEL version="1.0"

WORKDIR /app
ADD package*.json ./
RUN npm ci --production && npm cache clean --force
COPY . .
RUN npm run build

FROM nginx:stable-alpine
RUN apt-get update && apt-get install -y wget
HEALTHCHECK CMD wget -q --method=HEAD localhost/system-status.txt
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]