FROM phusion/baseimage:0.9.12
MAINTAINER Brant Fitzsimmons <brant.fitzsimmons@gmail.com>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV DEBIAN_FRONTEND noninteractive

# Update the system.
RUN echo "Acquire::http::Proxy \"http://172.17.42.1:3142\";" | tee /etc/apt/apt.conf.d/01proxy
RUN apt-get -qq update
RUN apt-get -qqy install aptitude
RUN aptitude -q=2 -y safe-upgrade

# Set the timezone and locale.
RUN echo "America/New_York" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
RUN export LANGUAGE=en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN export LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

# Install tools.
RUN apt-get -qqy install attr
RUN apt-get -qqy install curl
RUN apt-get -qqy install dstat
RUN apt-get -qqy install elinks
RUN apt-get -qqy install git
RUN apt-get -qqy install htop
RUN apt-get -qqy install iftop
RUN apt-get -qqy install locate
RUN apt-get -qqy install tree
RUN apt-get -qqy install vim
RUN apt-get -qqy install wget
RUN apt-get -qqy install dnsutils

# Install and configure dnsmasq.
RUN apt-get -qqy install dnsmasq
ADD /etc/dnsmasq.conf /etc/dnsmasq.conf
ADD /etc/dhosts /etc/dhosts
ADD /etc/service/dnsmasq/run /etc/service/dnsmasq/run
RUN chmod +x /etc/service/dnsmasq/run

# Create the webapp user.
RUN useradd -d /home/webapp -m -s /bin/bash webapp
RUN echo "webapp:webapp" | chpasswd
RUN echo "webapp ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up ssh. (finish this later)
USER webapp
RUN mkdir -p /home/webapp/.ssh
RUN chmod 700 /home/webapp/.ssh

# Add my public ssh key to the image.
USER webapp
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAlcX3TOr3iJsqQQLn3zPpBFbfPNI8yK8rq6vrolmi9RlnBpyUqo4IKMG1bJaDu+VYcGf0yQuY9uOOLp9bN5y5nj2ZMfUY3cUWXrUJRD6w8ty96FbcLXzoka5MXiPteHfV1gA451zQjxH1SEc/YCH9ZMUj0d27S/fKvYENW6acpxWWeDVBrgGpL9uwhXg6EIpq4wvyorYTltwUfbn/7n0dXKF/MSC3J7fzDyhRoYDQAY6CwiIfI1aaCJpk9puaG1yjj5tNDSKS9Eepz40rgFLhzwzL4ZYHgMLXsFIZ3woBU5O0jNc8a85jlnUV7BYYH972R0B9Kr83fxZupRwv+kuuLw== bfitzsimmons@azure.local" >> /home/webapp/.ssh/authorized_keys
RUN chmod 600 /home/webapp/.ssh/authorized_keys

# Clean up APT when done.
USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
