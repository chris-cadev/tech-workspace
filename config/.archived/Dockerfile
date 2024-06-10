FROM ubuntu:22.10

ENV HOME /home/christian

RUN apt update
RUN apt upgrade
RUN apt install -y sudo

RUN echo 'ping localhost &' > /keep-alive-bootstrap.sh
RUN echo 'sleep infinity' >> /keep-alive-bootstrap.sh
RUN chmod +x /keep-alive-bootstrap.sh

WORKDIR /home/christian/.dotfiles/

COPY . .
RUN apt install -y \
curl \
git 

CMD /keep-alive-bootstrap.sh
