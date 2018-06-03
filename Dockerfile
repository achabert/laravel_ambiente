    #
    # Ubuntu Dockerfile
    #
    # https://github.com/dockerfile/ubuntu
    #

    # Pull base image.
    FROM fcati/laravel_ambiente:0.3

    COPY ./supervisord.conf /etc/supervisor/conf.d/

    # Install.
    RUN \
        apt-get update \
        && apt-get -y upgrade \
      # Needed to spatie / browsershot / chromium
      && apt-get -y install libpangocairo-1.0-0 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libnss3 libcups2 libxss1 libxrandr2 libgconf2-4 libasound2 libatk1.0-0 libgtk-3-0 \
      # Cleaning
      && apt-get purge -y --auto-remove $BUILD_DEPS \
      && apt-get autoremove -y && apt-get clean \
      && rm -rf /var/lib/apt/lists/* \
      # Forward request and error logs to docker log collector
      && ln -sf /dev/stdout /var/log/apache2/access.log \
      && ln -sf /dev/stderr /var/log/apache2/error.log


    WORKDIR /var/www/html/app


    # Define default command.
    CMD ["/usr/bin/supervisord"]

