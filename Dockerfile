FROM postgres

RUN apt update && \
	apt install -y --no-install-recommends \
			postgresql-contrib \
			libpq-dev

<<<<<<< HEAD
VOLUME /config

COPY root/ /
=======
COPY root/ /
>>>>>>> 4347cc486d87a3e865899660984f591b3f65135c
