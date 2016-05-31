FROM debian:wheezy

MAINTAINER pokorny [dot] jan [dot] 94 [at] gmail [dot] com

# Install basics 
RUN apt-get update &&  \
    apt-get install -y git wget curl

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash - \
	&& apt-get install -y nodejs

# Install packages
RUN npm install -g \
		gulp \
		bower \
		grunt \
		ionic@beta \
		cordova 

COPY tools /opt/tools

# Expose port: web (8100), livereload (35729)
EXPOSE 8100 35729


#ANDROID
#JAVA

# ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-reconfigure debconf -f Noninteractive

# install python-software-properties (so you can do add-apt-repository)
RUN apt-get update && apt-get install -y -q python-software-properties software-properties-common

# install oracle java from PPA
# RUN add-apt-repository ppa:webupd8team/java -y
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
#echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
# RUN apt-get update && apt-get -y install oracle-java7-installer && apt-get clean

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update &&  \
    apt-get install -y oracle-java8-installer
    

#ANDROID STUFF
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect ant wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 && apt-get clean

# Install Android SDK
RUN cd /opt && wget --output-document=android-sdk.tgz --quiet https://dl.google.com/android/android-sdk_r24.0.2-linux.tgz && tar xzf android-sdk.tgz && rm -f android-sdk.tgz

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install sdk elements
ENV PATH ${PATH}:/opt/tools

RUN echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment

RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --all --no-ui --filter platform-tools,build-tools-22.0.1,android-23,addon-google_apis_x86-google-19,extra-android-support,extra-android-m2repository,extra-google-m2repository"]

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY tools/.bashrc /root/.bashrc
WORKDIR /data
