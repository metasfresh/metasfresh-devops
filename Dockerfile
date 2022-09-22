FROM ubuntu

RUN apt-get update && apt-get install -y mmv && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

# running foo tests
WORKDIR /java/foo
COPY --chmod=777 run-foo-tests.sh .
RUN ./run-foo-tests.sh 2>&1 | tee junit.log && echo "${PIPESTATUS[0]}" > junit.exit-code
COPY results-01.xml comp/target/surefire-reports/

# running bar tests
WORKDIR /java/bar
RUN echo 'running bar maven junit tests...' 2>&1 | tee junit.log && echo "${PIPESTATUS[0]}" > junit.exit-code
COPY results-02.xml comp/target/surefire-reports/

WORKDIR /java

VOLUME /reports

CMD set -o pipefail \
	&& shopt -s globstar \
	&& find **/target/surefire-reports/*.xml -printf "%h\n" | uniq | sed 's/\/target\/surefire-reports//' | sed 's/^/\/reports\//' | xargs mkdir -p \
	&& mcp ';target/surefire-reports/*.xml' '/reports/#1#2.xml' \
	&& mcp ';junit.*' '/reports/#1junit.#2'
