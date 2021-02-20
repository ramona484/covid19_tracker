# build environment
FROM node:14.15-stretch as builder
WORKDIR app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
USER root
CMD ["nginx", "-g", "daemon off;"]