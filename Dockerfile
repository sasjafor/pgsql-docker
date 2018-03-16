FROM postgres

RUN apt update && \
	apt install -y --no-install-recommends \
			postgresql-contrib \
			libpq-dev

VOLUME /config

COPY root/ /