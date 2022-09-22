FROM ubuntu

RUN apt-get update && apt-get install -y mmv && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

WORKDIR /java/foo
RUN echo 'running maven junit tests...' 2>&1 | tee junit.log && echo "$?" > junit.exit-code
COPY results.xml comp/target/surefire-reports/

WORKDIR /java

VOLUME /reports

CMD set -o pipefail \
	&& shopt -s globstar \
	&& find **/target/surefire-reports/*.xml -printf "%h\n" | uniq | sed 's/\/target\/surefire-reports//' | sed 's/^/\/reports\//' | xargs mkdir -p \
	&& mcp ';target/surefire-reports/*.xml' '/reports/#1#2.xml' \
	&& cp foo/junit.* /reports/foo/
