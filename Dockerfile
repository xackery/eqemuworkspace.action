FROM eqemu/workspace

WORKDIR /home/eqemu

USER root 

ADD entrypoint.sh /entrypoint.sh
ADD build.sh /build.sh
ENTRYPOINT ["/entrypoint.sh"]