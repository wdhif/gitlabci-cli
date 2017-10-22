# Copyright (c) 2017 rockyluke
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Amsterdam

RUN apt-get update -qq && \
    apt-get upgrade -qq -y && \
    apt-get install -qq -y \
      build-essential \
      bundler \
      git-core \
      ruby \
      ruby-dev \
      rubygems && \
    apt-get autoclean && \
    apt-get autoremove

RUN git clone https://github.com/wdhif/gitlabci-cli.git /usr/src && \
    cd /usr/src && \
    bundle install

WORKDIR /usr/src

ENTRYPOINT [ "bundle", "exec", "gitlabci-cli" ]

CMD [ "help" ]
# EOF
