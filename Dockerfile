FROM node:gallium-buster-slim as build

WORKDIR /usr/local/app
# Add the source code to app
COPY ./ /usr/local/app/
# Install all the dependencies
RUN npm ci
# Generate the build of the application
RUN npm run build

###############
### STAGE 2: Serve app with nginx ###
###############
FROM nginx:alpine-slim
COPY  --from=build /usr/local/app/dist/angular-docker /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# When the container starts, replace the env.js with values from environment variables
CMD ["/bin/sh",  "-c",  "envsubst < /usr/share/nginx/html/assets/env.sample.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]