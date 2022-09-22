FROM ubuntu

WORKDIR /tests

SHELL ["/bin/bash", "-c"]

RUN echo 'running maven junit tests...' 2>&1 | tee junit.log \
	&& echo "$?" > junit.exit-code

VOLUME /reports

CMD set -o pipefail \
	&& shopt -s globstar \
	&& cp junit.* /reports/
