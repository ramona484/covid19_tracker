# build environment
FROM node:14.15.4-alpine3.12 as builder
WORKDIR /app
COPY package.json ./
COPY package-lock.json ./
RUN npm install 
COPY . ./
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]    