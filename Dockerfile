FROM debian:stable-slim

MAINTAINER Luca Pasquali <lpasquali@gmail.com>

RUN addgroup --system psilocybe \
    && adduser \
    --home /home/semilanceata \
    --disabled-password \
    --shell /bin/bash \
    --gecos "user for running things under wine" \
    --ingroup psilocybe \
    --quiet \
    semilanceata

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y curl unzip ca-certificates wget rename procps 

RUN apt-get install -y wine wine32


RUN curl -SL "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" -o /usr/local/bin/winetricks
RUN chmod +x /usr/local/bin/winetricks
#RUN mkdir -p /usr/share/wine/mono && \
#    curl -SL 'http://sourceforge.net/projects/wine/files/Wine%20Mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION.msi/download'\
#    -o /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi \
#    && chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi


# Wine really doesn't like to be run as root, so let's use a non-root user
USER semilanceata
ENV HOME /home/semilanceata
ENV WINEPREFIX /home/semilanceata/.wine
ENV WINEARCH win32
WORKDIR /home/semilanceata


USER root
COPY waitonprocess.sh /scripts/
COPY start.sh /scripts/
RUN chmod +x /scripts/waitonprocess.sh /scripts/start.sh
# Install .NET Framework 4.0
USER semilanceata
RUN wine wineboot --init \
        && /scripts/waitonprocess.sh wineserver \
        && winetricks --unattended dotnet40 dotnet_verifier \
        && /scripts/waitonprocess.sh wineserver

RUN    rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/man \
    && rm -rf /usr/share/doc

