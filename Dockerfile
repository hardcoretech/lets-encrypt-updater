FROM python:3.7.6-slim
LABEL maintainer=hardcore

# Setup dependencies
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
        cron \
        rsyslog \
        git \
        curl \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/cron.daily/* \
    && sed -i 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/' /etc/pam.d/cron

# Install dehydrated (letsencrypt client) & dns-lexicon
RUN git clone --depth 1 https://github.com/lukas2511/dehydrated.git /srv/dehydrated \
    && pip install --no-cache-dir \
        requests[security] \
        dns-lexicon[route53]

# Copy over dehydrated and & cron files
COPY ./build/dehydrated.default.sh /srv/dehydrated/dehydrated.default.sh
COPY ./build/crontab /etc/crontab
COPY ./build/cron.sh /srv/dehydrated/cron.sh

# Configure dehydrated and Cron
RUN echo "*.example.com > star_example_com" > /srv/dehydrated/domains.txt \
    && chmod +x /srv/dehydrated/cron.sh \
    && crontab /etc/crontab \
    && touch /var/log/cron \
    # link STDOUT to docker logs
    && ln -sf /proc/1/fd/1 /var/log/cron

CMD ["/srv/dehydrated/cron.sh"]

