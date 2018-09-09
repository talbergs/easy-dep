FROM animaacija/crystal-alpine:0.26.0 as crystal-builder

WORKDIR /home
COPY . .
RUN shards install
RUN crystal build src/app.cr --static --release --no-debug

FROM node as js-builder
WORKDIR /home
COPY client .
RUN npm install && npm run build

FROM alpine
WORKDIR /home
COPY --from=crystal-builder /home/app ./
COPY --from=js-builder /home/dist ./client/dist

EXPOSE 3000
VOLUME ["./scripts", "./conf.json"]
CMD ["./app", "./conf.json", "./scripts", "./client"]

