### [lpasquali/wine](https://hub.docker.com/r/lpasquali/wine)

This Dockerfile creates an image based on Debian GNU/Linux stable official
image [debian:stable-slim](https://hub.docker.com/_/debian/) where is
installed stock debian wine and then winetricks and dotnet40 are downloaded
from their standard locations. This image should be used to build images
bearing Microsoft Windows software running under wine. Here I provide
a n example docker file with [Putty.exe](http://www.putty.org/) ssh client for
windows.

```
FROM lpasquali/wine:latest
USER semilanceata
RUN mkdir $HOME/putty
RUN curl -SL 'https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe' -O $HOME/putty/putty.exe
CMD ["/usr/bin/wine /home/semilanceata/putty/putty.exe"]
```
