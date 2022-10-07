FROM ubuntu

RUN apt-get update && apt-get install -y mmv && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

COPY --chmod=777 run-tests.sh /frontend/bozo/


# running bozo tests
# error - failing hard - execution fails - probably no test results
WORKDIR /frontend/bozo
RUN ./run-tests.sh 2>&1 | tee jest.log && echo "${PIPESTATUS[0]}" > jest.exit-code


# running contozo tests
# failure - failing soft - test fail - with test results
WORKDIR /frontend/contozo
RUN echo -e 'running contozo yarn jest tests...\ntest-137 failed somehow...\nDANG IT' 2>&1 | tee jest.log && echo "${PIPESTATUS[0]}" > jest.exit-code
COPY fail.xml jest.xml


# running propozo tests
# utter success - pristine test results
WORKDIR /frontend/propozo
RUN echo -e 'running propozo yarn jest tests...\nhuge success\nWHAT A DAY TO BE ALIVE' 2>&1 | tee jest.log && echo "${PIPESTATUS[0]}" > jest.exit-code
COPY success.xml jest.xml

WORKDIR /frontend

VOLUME /reports

CMD mkdir /reports/bozo /reports/contozo /reports/propozo \
	&& cp bozo/jest.* /reports/bozo/ \
	&& cp contozo/jest.* /reports/contozo/ \
	&& cp propozo/jest.* /reports/propozo/
