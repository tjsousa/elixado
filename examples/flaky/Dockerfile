FROM trenpixster/elixir
MAINTAINER Tiago Sousa <tiago.joao@gmail.com>

ENV APP_HOME /flaky
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD mix.* $APP_HOME/

# RUN mix deps.get
# RUN mix compile

ADD config/ $APP_HOME/config/

ADD . $APP_HOME/
