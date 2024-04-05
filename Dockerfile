FROM node:18
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY hello-world-app/  /usr/src/app
COPY run.sh /usr/src/app
RUN npm install
RUN chmod +x run.sh
CMD [ "/usr/src/app/run.sh" ]
