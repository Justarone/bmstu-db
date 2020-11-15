FROM postgres:latest

RUN apt-get update
RUN apt-get -y install python3 postgresql-plpython3-12
