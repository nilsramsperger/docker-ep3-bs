FROM ubuntu:latest
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y tzdata \
    && ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get update \
    && apt-get install apache2 unzip php php-mysql php-intl php-dom php-soap php-mbstring php-zip libapache2-mod-php wget -y
RUN a2enmod rewrite
RUN cd /var/www/html/ \
    && wget https://github.com/tkrebs/ep3-bs/archive/1.6.4.tar.gz \
    && rm index.html \
    && tar -xf 1.6.4.tar.gz \
    && rm 1.6.4.tar.gz \
    && mv ./ep3-bs-1.6.4/* ./ \
    && rm -r ep3-bs-1.6.4/ \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '8a6138e2a05a8c28539c9f0fb361159823655d7ad2deecb371b04a83966c61223adc522b0189079e3e9e277cd72b8897') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && php composer.phar install
RUN cd /var/www/html/config/autoload \
    && mv local.php.dist local.php
RUN cd /var/www/html/config \
    && mv init.php.dist init.php
RUN cd /var/www/html \
    && chown www-data:www-data -R *
CMD ["apachectl", "-D", "FOREGROUND"]