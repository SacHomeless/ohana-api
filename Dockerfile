FROM ubuntu:17.10

RUN apt-get update

RUN apt-get install -y openssh-server git-core openssh-client curl vim build-essential \
    openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev \
    libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake \
    libtool bison pkg-config gawk libgdbm-dev libgmp-dev libgdm-dev libffi-dev libpq-dev \
    postgresql-client nodejs ruby ruby-dev npm libfontconfig

RUN npm install -g phantomjs
RUN gem install bundler

RUN adduser --disabled-password sacsos

USER sacsos

RUN mkdir /home/sacsos/api

WORKDIR /home/sacsos/api

COPY . /home/sacsos/api/
USER root
RUN  chown -R sacsos /home/sacsos/api
USER sacsos

RUN echo "gem: --no-document" > /home/sacsos/.gemrc
RUN bundle --path /home/sacsos/.bundled_gems

EXPOSE 3001

CMD /bin/bash -l -c "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3000"
