FROM zultron/docker-dev:latest

# Install recent nodejs
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y \
        nodejs && \
    apt-get clean

# Install machinekit 
RUN apt-get update \
    && apt-get install -y \
        machinekit-posix \
	avahi-daemon \
	rsyslog \
    && apt-get clean

RUN apt-get install -y \
	avahi-utils \
	python-yaml \
	python-rrdtool \
    && apt-get clean

# Add MK INI file with remote enabled
ADD machinekit.ini /etc/linuxcnc/machinekit.ini

# Fix avahi execution https://github.com/lxc/lxc/issues/25
RUN sudo sed -i /etc/avahi/avahi-daemon.conf -e '/rlimit-nproc/ s/^/#/'
