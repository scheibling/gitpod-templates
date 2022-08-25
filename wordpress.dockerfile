FROM gitpod/workspace-mysql:latest

ENV PHPVER="8.1"

# Install general packages
RUN sudo apt-get update && sudo apt-get -y upgrade
RUN sudo apt-get -y install lsb-release apt-utils python libmysqlclient-dev \
    curl wget apt-transport-https libnss3-dev openssh-client software-properties-common \
    zip unzip git supervisor

RUN sudo add-apt-repository -y ppa:ondrej/php \
    && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62 \
    && sudo apt-get update

# Install PHP packages
COPY config/install_php_dev.sh install_php_dev.sh
RUN sudo rm -rf /etc/apache2 \
    && sudo chmod +x install_php_dev.sh \
    && sudo bash install_php_dev.sh "php$PHPVER"

# Install Composer
RUN sudo php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --version=1.10.16 --filename=composer

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && php wp-cli.phar --info \
    && sudo mv wp-cli.phar /usr/local/bin/wp

# Cleanup
RUN sudo apt-get -y autoremove && sudo apt-get -y clean