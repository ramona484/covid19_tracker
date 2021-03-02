FROM node:lts-stretch AS builder
LABEL version="1.0"

WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY . .
RUN npm run build


FROM nginx:1.19.7-perl AS production
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


FROM production AS vulnscan
COPY --from=aquasec/trivy:0.16.0 /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy filesystem --exit-code 1 --no-progress /