FROM ubuntu:20.10
RUN apt update && \
apt install -y ruby-dev libssl-dev build-essential && \
gem install openssl -v 2.2.0
#RUN mkdir /certie
COPY . /certie
WORKDIR /certie
RUN gem build certie.gemspec && \
gem install certie-0.0.4.gem
CMD ["/bin/bash"]
