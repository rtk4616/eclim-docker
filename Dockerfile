FROM ubuntu:latest
MAINTAINER w0lker w0lker.tg@gmail.com

RUN useradd -m -U -s /bin/bash eclim 

RUN apt-get -y update \
    && apt-get install -y build-essential wget xvfb x11vnc x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps \
    && apt-get -y clean all

ADD xvfb_init /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb
ADD xvfb_daemon_run /usr/bin/xvfb-daemon-run
RUN chmod a+x /usr/bin/xvfb-daemon-run
ENV DISPLAY :99

RUN wget --no-check-certificate --header="Cookie: oraclelicense=a" \
  -O- http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.tar.gz | tar zx -C /opt
RUN ln -sf /opt/jdk1.8.0_25/bin/* /usr/local/bin

ENV HOME /home/eclim
USER eclim
WORKDIR $HOME

RUN wget -O /tmp/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz http://ftp.jaist.ac.jp/pub/eclipse/technology/epp/downloads/release/neon/2/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz && tar -zxf /tmp/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz -C $HOME && rm -rf /tmp/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz
RUN DISPLAY=:99 $HOME/eclipse/eclipse -nosplash -consolelog -debug -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/neon -installIU org.eclipse.wst.web_ui.feature.feature.group

RUN wget https://github.com/ervandew/eclim/releases/download/2.6.0/eclim_2.6.0.jar
RUN java -Dvim.skip=true -Declipse.home=$HOME/eclipse -jar eclim_2.6.0.jar install && rm -rf eclim_2.6.0.jar
