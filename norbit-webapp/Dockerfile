FROM node:20-bullseye
# Valid values: prod, dev
ARG BUILD_MODE=prod

WORKDIR /app/

# Cache dependency layer
COPY package.json package-lock.json /app
RUN npm install

# Copy the entire working directory
COPY . /app/
ENV BUILD_MODE=$BUILD_MODE

EXPOSE 3000

CMD ["/app/scripts/docker_run.sh"]
