FROM ubuntu:trusty
MAINTAINER Kasyfil Aziz Tri Cahyana <tricahyana@windowslive.com>

RUN apt-get update && apt-get install -y apache2 supervisor openssh-server
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

# setup ssh
# password : admin
RUN echo 'root:admin' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22 80

# start apache2
CMD bash -c "source /etc/apache2/envvars ; \ 
	service apache2 restart ; \
	/usr/sbin/sshd -D"

