#gsdenys/ephesoft

FROM centos:6
MAINTAINER Denys G. Santos <gsdenys@gmail.com>

#ADD yum repository for MariaDB
ADD assets/MariaDB.repo /etc/yum.repos.d/MariaDB.repo

#Update repositories
RUN yum update -y

#Install MariaDB
RUN yum install MariaDB-server MariaDB-client -y

#Install dependencies
RUN yum install -y perl \
				   m4 \
				   unzip \
				   tar \
				   fipscheck \
				   freetype \
				   GConf2 \
				   gnome-vfs2 \
				   iptables \
				   wget

#Install autoconf
ADD assets/install-autoconf.sh /tmp/install-autoconf.sh
RUN /tmp/install-autoconf.sh

#Add ephesoft installer to the tmp directory
#ADD assets/Ephesoft_Community_Release_4.0.2.0.zip /tmp/ephesoft.zip
ADD http://www.ephesoft.com/Ephesoft_Product/Ephesoft_Community_4.0.2.0/Ephesoft_Community_Release_4.0.2.0.zip /tmp/ephesoft.zip

#Configure environment to ephesoft instalation
ADD assets/configure.sh /tmp/configure.sh
RUN /tmp/configure.sh

#Install ephesoft
WORKDIR /tmp/installer
RUN ./install-helper -silentinstall

#Run Post Install Script
WORKDIR /tmp/
ADD assets/post-install.sh /tmp/post-install.sh
RUN /tmp/post-install.sh

#add startup script
ADD assets/startup.sh /etc/init.d/startup.sh

#Set default workdir and expose 8080
WORKDIR /
EXPOSE 8080

#show ephesoft log on startup
CMD ["/etc/init.d/startup.sh"]