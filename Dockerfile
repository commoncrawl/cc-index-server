# as of Jan 2025, python3 on production is on 3.8.10
FROM python:3.11-bullseye

# Create a virtualenv for the app
RUN python3 -m venv /var/venv
ENV PATH="/var/venv/bin:$PATH"

RUN apt install libpcre3-dev
RUN pip install --upgrade pip setuptools

# Install dependencies
COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -Ur /tmp/requirements.txt

# Add the cc-index-server code into the image
COPY ./ /opt/webapp/
WORKDIR /opt/webapp

VOLUME /opt/webapp/collections

CMD uwsgi --ini uwsgi.ini
