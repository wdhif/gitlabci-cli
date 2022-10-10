FROM debian:bullseye

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      build-essential \
      bundler \
      git-core \
      ruby \
      ruby-dev \
      rubygems && \
    apt-get autoclean && \
    apt-get autoremove

RUN git clone https://github.com/wdhif/gitlabci-cli.git /usr/src
WORKDIR /usr/src
RUN bundle install

ENTRYPOINT [ "bundle", "exec", "gitlabci-cli" ]

CMD [ "help" ]
