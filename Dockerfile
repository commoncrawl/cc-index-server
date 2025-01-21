# as of Jan 2025, python3 on production is on 3.8.10
FROM python:3.8.10

RUN apt-get -qq update && apt-get -qqy install awscli

# Create a virtualenv for the app
RUN python3 -m venv /var/venv
ENV PATH="/var/venv/bin:$PATH"

# Install dependencies
COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -Ur /tmp/requirements.txt

# Add the cc-index-server code into the image
COPY ./ /opt/webapp/
WORKDIR /opt/webapp

VOLUME /opt/webapp/collections

ARG INSTALL_COLLECTIONS=true
RUN if [ "$INSTALL_COLLECTIONS" = "true" ]; then \
        ./install-collections.sh; \
    fi

CMD uwsgi --ini uwsgi.ini
