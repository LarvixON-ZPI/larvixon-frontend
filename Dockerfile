# Stage 1: Install Flutter SDK (cached)
FROM debian:latest AS flutter-sdk
ARG FLUTTER_VERSION=3.35.1
ARG FLUTTER_SDK=/usr/local/flutter

RUN apt-get update && apt-get install -y curl git unzip xz-utils \
    && curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    && tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -C /usr/local \
    && rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    && git config --global --add safe.directory /usr/local/flutter

ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"
ENV FLUTTER_WEB_ONLY=true

# Stage 2: Build Flutter app
FROM debian:latest AS build-env
ARG API_BASE_URL=http://localhost:8000/api
ARG APP=/app/

# Copy SDK from previous stage (cached)
COPY --from=flutter-sdk /usr/local/flutter /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Install dependencies
RUN apt-get update && apt-get install -y git unzip xz-utils \
    && git config --global --add safe.directory /usr/local/flutter

# Set workdir
WORKDIR $APP

# Copy only pubspec first for caching dependencies
COPY pubspec.* $APP/
RUN flutter pub get

# Then copy the rest of the source code
COPY . $APP

# Build
RUN flutter clean \
    && flutter build web --dart-define=API_BASE_URL=$API_BASE_URL

# Stage 3: Serve with Nginx
FROM nginx:1.25.2-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
