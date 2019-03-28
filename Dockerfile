FROM bregell/steamcmd
MAINTAINER Johan Bregell

ENV WINEARCH=win64
ENV WINEDEBUG=-all

USER root
RUN apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		software-properties-common \
		apt-transport-https \
		xvfb
RUN dpkg --add-architecture i386
RUN wget -nc https://dl.winehq.org/wine-builds/Release.key \
	&& apt-key add Release.key \
	&& apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
RUN	apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests --allow-unauthenticated \
		winehq-devel \
		cabextract \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN wget 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks'
RUN	mv winetricks /usr/bin/winetricks
RUN chmod +x /usr/bin/winetricks
RUN WINEDLLOVERRIDES="mscoree,mshtml=" wineboot --init && \
	xvfb-run winetricks -q vcrun2013 vcrun2017
RUN wineboot --init && \
	winetricks -q dotnet472 corefonts
RUN wineboot --init && \
	winetricks -q dxvk
