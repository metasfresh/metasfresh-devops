FROM ubuntu

RUN apt-get update && apt-get install -y mmv && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

COPY --chmod=777 run-tests.sh /java/foo/

# running foo tests
# error - failing hard - execution fails - probably no test results
WORKDIR /java/foo
RUN ./run-tests.sh 2>&1 | tee junit.log && echo "${PIPESTATUS[0]}" > junit.exit-code
RUN cat junit.log | grep -q "BUILD SUCCESS" && echo "$?" > junit.mvn.exit-code || echo "$?" > junit.mvn.exit-code


# running bar tests
# failure - failing soft - test fail - with test results
WORKDIR /java/bar
RUN echo -e 'running bar maven junit tests...\ntest-137 failed somehow...\nBUILD FAILURE' 2>&1 | tee junit.log && echo "${PIPESTATUS[0]}" > junit.exit-code
COPY fail.xml comp/target/surefire-reports/junit.xml
RUN cat junit.log | grep -q "BUILD SUCCESS" && echo "$?" > junit.mvn.exit-code || echo "$?" > junit.mvn.exit-code


# running baz tests
# utter success - pristine test results
WORKDIR /java/baz
RUN echo -e 'running baz maven junit tests...\nBUILD SUCCESS' 2>&1 | tee junit.log && echo "${PIPESTATUS[0]}" > junit.exit-code
COPY success.xml comp/target/surefire-reports/junit.xml
RUN cat junit.log | grep -q "BUILD SUCCESS" && echo "$?" > junit.mvn.exit-code || echo "$?" > junit.mvn.exit-code


WORKDIR /java

VOLUME /reports

CMD set -o pipefail \
	&& shopt -s globstar \
	&& find **/target/surefire-reports/*.xml -printf "%h\n" | uniq | sed 's/\/target\/surefire-reports//' | sed 's/^/\/reports\//' | xargs mkdir -p \
	&& find **/junit.log -printf "%h\n" | uniq | sed 's/^/\/reports\//' | xargs mkdir -p \
	&& mcp ';target/surefire-reports/*.xml' '/reports/#1#2.xml' \
	&& mcp ';junit.*' '/reports/#1junit.#2'
