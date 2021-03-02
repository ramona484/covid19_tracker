FROM node:14.15-stretch as builder
LABEL version="1.0"


WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY . .
RUN npm run build

# Run vulnerability scan on build image
FROM aquasec/trivy:0.16.0 AS vulnscan
RUN trivy filesystem --exit-code 0 --no-progress /

FROM nginx:1.18
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]