FROM ubuntu:14.04
MAINTAINER Brant Fitzsimmons <brant.fitzsimmons@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Update the system.
RUN apt-get -qq update
RUN apt-get -qqy install aptitude
RUN aptitude -q=2 -y safe-upgrade

# Set the timezone and locale.
RUN aptitude -q=2 -y install locales
RUN echo "America/New_York" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
RUN export LANGUAGE=en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN export LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

# Install tools.
RUN aptitude -q=2 -y install attr
RUN aptitude -q=2 -y install curl
RUN aptitude -q=2 -y install dstat
RUN aptitude -q=2 -y install elinks
RUN aptitude -q=2 -y install git
RUN aptitude -q=2 -y install htop
RUN aptitude -q=2 -y install iftop
RUN aptitude -q=2 -y install locate
RUN aptitude -q=2 -y install tree
RUN aptitude -q=2 -y install vim
RUN aptitude -q=2 -y install wget

# Create the webapp user.
RUN useradd -d /home/webapp -m -s /bin/bash webapp
ENV HOME /home/webapp
RUN echo "webapp:webapp" | chpasswd
RUN echo "webapp ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
