FROM animaacija/easy-dep

# of course, one may install a curl and do API requests that way.
# these are easier with /var/run/docker.sock (if volume is bound)

#
# docker
RUN apk update
RUN apk add docker

#
# docker-compose
RUN apk add py-pip
RUN pip install docker-compose

