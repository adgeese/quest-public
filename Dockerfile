FROM node:10

# Project Target: SECRET WORD is Strawberry
ENV SECRET_WORD="Strawberry"

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
COPY src/* ./

# Copy Binaries into the ./bin directory
RUN mkdir bin
COPY bin/* ./bin/

# Package installation
RUN npm install

EXPOSE 3000
CMD [ "node", "000.js" ]

