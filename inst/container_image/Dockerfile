FROM docker.io/r-base:latest
RUN apt-get update \
	&& apt-get install -y openssh-server libhiredis-dev
COPY install-R-deps-build-stage.R /
RUN Rscript install-R-deps-build-stage.R
COPY . /workspace
CMD bash /workspace/worker_commands
WORKDIR /workspace