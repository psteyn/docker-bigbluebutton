FROM ubuntu:14.04
MAINTAINER Pieter Steyn pieterste@gmail.com
ENV DEBIAN_FRONTEND noninteractive

#Big Blue Button 1.0 as per http://docs.bigbluebutton.org/install/install.html

RUN apt-get -y update
RUN apt-get install -y language-pack-en vim wget
RUN update-locale LANG=en_US.UTF-8
RUN dpkg-reconfigure locales

#Add multiverse repo
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty multiverse" | tee -a /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y dist-upgrade

#Install LibreOffice
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:libreoffice/libreoffice-4-4
#Chrome libraries
RUN add-apt-repository -y ppa:ondrej/php

#Install key for BigBlueButton
RUN wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | sudo apt-key add -
#BigBlueButton Repo
RUN echo "deb http://ubuntu.bigbluebutton.org/trusty-1-0/ bigbluebutton-trusty main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list
RUN apt-get -y update

#Install ffmpeg
ADD newscripts/install-ffmpeg.sh /usr/local/bin/
RUN /usr/local/bin/install-ffmpeg.sh

#Install Tomcat7 and overwrite bugged init script
ADD newscripts/tomcat7 /etc/init.d/
RUN apt-get -y install tomcat7
ADD newscripts/tomcat7 /etc/init.d/

#Install BigBlueButton
#RUN apt-get -y  --force-yes install bigbluebutton

#Install Demo files for now
#RUN apt-get -y  --force-yes install bbb-demo

##Enable WebRTC audio
#RUN bbb-conf --enablewebrtc

#Clean restart
#RUN bbb-conf --clean
#RUN bbb-conf --check
#
#EXPOSE 80 9123 1935
