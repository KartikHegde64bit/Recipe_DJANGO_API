# python image used
FROM python:3.9-alpine3.13
# info about author/ maintainer
LABEL maintainer="KartikHegde64Bit"

ENV PYTHONUNBUFFERED 1

# copy req file to doc image
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# copy the app to /app on doc image
COPY ./app /app
# the path will be reference from here
WORKDIR /app
# the server will be available from 8000
EXPOSE 8000

# set to true if wants to be run in development mode
ARG DEV=false

# runs command in the above mentioned image (i.e python image)
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
        if [ $DEV = "true" ]; \
            then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
        fi && \
    rm -rf /tmp && \
    # to avoid adding root user(for security reasons), we are adding custom user
    adduser \
        --disabled-password \
        --no-create-home \
        django-user
ENV PATH="/py/bin:$PATH"

USER django-user