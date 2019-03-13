FROM bregell/steamcmd
MAINTAINER Johan Bregell

ENV DISPLAY=
ENV WINEDEBUG=-all

USER root
RUN apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		software-properties-common \
		apt-transport-https
RUN dpkg --add-architecture i386
RUN wget -nc https://dl.winehq.org/wine-builds/Release.key \
	&& apt-key add Release.key \
	&& apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
RUN	apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests --allow-unauthenticated\
		winehq-stable \
		cabextract \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN wget 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks'
RUN	mv winetricks /home/root/winetricks
RUN chmod +x /home/root/winetricks
RUN wineboot --init && \
	~/winetricks -q dotnet461
RUN wine64 wineboot
