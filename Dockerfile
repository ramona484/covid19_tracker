FROM node:lts-buster-slim AS builder
LABEL version="ramona.rettig@t-online.de"

WORKDIR /app
ADD package*.json ./
RUN npm ci --production
ADD . .
RUN npm run build

FROM nginx:stable-alpine AS production
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]



