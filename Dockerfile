FROM jekyll/jekyll:builder as builder

COPY ./ ./

# Build the website and move it outside the volume
RUN jekyll build . && mv _site /srv/site



FROM alpine:latest

MAINTAINER KoMa Admins <homepage@die-koma.org>

# install lighthttpd
RUN apk add --no-cache lighttpd

# add the built website to the lighttpd default location
COPY --from=builder /srv/site /var/www/localhost/htdocs

# expose the default port
EXPOSE 80

# run lighttpd with the default configuration
# it will drop its previliges by itself
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
