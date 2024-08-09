# DJango COnfiguration
FROM python:3.10.14-slim-bullseye

RUN apt-get update && \
    apt-get install -y build-essential python3-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY . .

RUN pip install --upgrade pip

RUN pip install -r requirements.txt
