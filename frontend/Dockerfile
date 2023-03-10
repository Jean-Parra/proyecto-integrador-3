FROM cirrusci/flutter AS build

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY . .

RUN flutter pub get

RUN flutter build web --release

FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
