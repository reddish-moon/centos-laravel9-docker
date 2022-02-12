FROM centos:7

# set user
RUN useradd -u 1000 user

# よく使うものも一緒に適当に入れておく
RUN yum update -d 1 -y && \
    yum install -d 1 -y yum-utils epel-release && \
    yum install -d 1 -y http://ftp.riken.jp/Linux/remi/enterprise/remi-release-7.rpm && \
    yum-config-manager --disable epel && \
    yum -d 1 makecache && \
    yum install -d 1 -y --enablerepo=epel,remi,remi-php81 \
    vim \
    wget \
    zip \
    make \
    unzip \
    jq \
    git \
    sudo \
    httpd \
    httpd-devel \
    php81.x86_64 \
    php81-build.x86_64 \
    php81-php-devel.x86_64 \
    php81-php.x86_64 \
    php81-php-cli.x86_64 \
    php81-php-common.x86_64 \
    php81-php-mbstring.x86_64 \
    php81-php-opcache.x86_64 \
    php81-php-pear.noarch \
    php81-php-pdo.x86_64 \
    php81-php-mysqlnd.x86_64 \
    php81-php-pecl-mcrypt.x86_64 \
    php81-php-pecl-mysql.x86_64 \
    php81-php-process.x86_64 \
    php81-php-xml.x86_64 \
    php81-php-pecl-apcu.x86_64 \
    php81-php-pecl-apcu-devel.x86_64 \
    php81-php-pecl-zip.x86_64 \
    php81-php-pecl-http.x86_64 \
    php81-php-pecl-http-devel.x86_64

# いらないファイルがあればインストール直後に削除
#RUN rm -f /etc/httpd/conf.d/welcome.conf \
#  /etc/httpd/conf.d/userdir.conf

RUN echo 'user    ALL=(ALL)    NOPASSWD:ALL' >> /etc/sudoers.d/user

ENV PATH $PATH:/opt/remi/php81/root/usr/bin/

RUN echo 'PATH=$PATH:/opt/remi/php81/root/usr/bin/' >> /etc/bashrc
RUN ln -s /etc/opt/remi/php81/php.ini /etc/php.ini && \
  ln -s /etc/opt/remi/php81/php.d /etc/php.d

RUN cd /usr/local/src && \
  wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm && \
  rpm -ivh ./mysql80-community-release-el7-3.noarch.rpm && \
  rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022 && \
  sed -i "s/enabled=.*/enabled=0/g" /etc/yum.repos.d/mysql-community.repo && \
  yum -d 1 --enablerepo=mysql57-community clean metadata && \
  yum -d 1 --enablerepo=mysql57-community makecache && \
  yum -d 1 --enablerepo=mysql57-community install -y mysql-community-client mysql-community-devel

RUN yum clean all

RUN usermod -a -G user apache
COPY ./apache-php/conf/httpd.conf /etc/httpd/conf/httpd.conf
COPY ./apache-php/conf.d/www.conf /etc/httpd/conf.d/www.conf
COPY ./apache-php/conf.modules.d/01-env.conf /etc/httpd/conf.modules.d/01-env.conf

# php.iniに何か足したければこれ
COPY ./apache-php/add.ini /etc/opt/remi/php81/php.d/

# 何故かRUNだと上手くいかなかったのでshellに
COPY ./apache-php/install_composer.sh /
RUN sh install_composer.sh

# laravel install
RUN su - user -c "composer global require laravel/installer"
RUN su - user -c "composer global require fruitcake/laravel-cors"

RUN mkdir -p /var/www/laravel && chown user /var/www/laravel

RUN su - user -c "cd /var/www && export COMPOSER_PROCESS_TIMEOUT=1200;composer clear-cache && \
  composer create-project --prefer-dist laravel/laravel laravel '9.*'"

# Docker runした時にそのまま動かすならこういう事する
#COPY --chown=user:user ./laravel /var/www/laravel
#COPY --chown=user:user ./laravel/.env /var/www/laravel/.env
#RUN su - user -c "mkdir -p /var/www/laravel/storage/logs/"

#RUN su - user -c "cd /var/www/laravel && \
#  composer --no-progress install"


COPY ./apache-php/entrypoint.sh /entrypoint.sh
EXPOSE 80
#ENTRYPOINT /bin/sh -c "while :; do sleep 10; done"
ENTRYPOINT ["sh","-x", "/entrypoint.sh"]
