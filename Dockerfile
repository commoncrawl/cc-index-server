# as of Jan 2025, python3 on production is on 3.8.10
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    linux-headers-virtual \
    make \
    gcc \
    git \
    curl \
    nano \
    libev-dev \
    libssl-dev \
    libc-dev \
    libffi-dev \
    libpcre3-dev \
    python3.9-full \
    python3.9-dev \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 2 && \
    update-alternatives --set python3 /usr/bin/python3.9

RUN apt-get update && apt-get install -y \
    python3-venv \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    python3-cffi \
    python3-pytest \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /var/venv
ENV PATH="/var/venv/bin:$PATH"

#RUN pip install --upgrade pip setuptools wheel
#RUN pip install "Cython<3" "setuptools<58"

# Install dependencies
COPY ./requirements.txt /tmp/requirements.txt
#RUN pip download --no-binary :all: --no-deps gevent==20.9.0
#RUN pip download --no-binary :all: --no-deps gevent==20.9.0
#RUN pip install gevent-20.9.0.tar.gz
RUN pip install -Ur /tmp/requirements.txt

# Add the cc-index-server code into the image
COPY ./ /opt/webapp/
WORKDIR /opt/webapp

VOLUME /opt/webapp/collections

CMD uwsgi --ini uwsgi.ini
