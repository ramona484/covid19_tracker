# build environment
FROM node:14.15-stretch as builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --production && npm cache clean --force
COPY . .
RUN npm run build

FROM nginx:1.18
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]