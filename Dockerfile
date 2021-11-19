FROM centos:7

MAINTAINER Vladimir Bobarykin <vlad@net-admins.ru>

ENV NOTVISIBLE "in users profile"

RUN cd /tmp && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum remove firewalld -y \
    && yum install whois tcpdump iproute kmod expect which tzdata mc bzip2 net-tools traceroute tcpdump nload audit-libs zlib cracklib pam openssh-server supervisor sudo -y \
    && yum clean all \
    && yum autoremove -y \
    # Here set root user-pass in builded image:
    && echo 'root:newpassword' | chpasswd \
    # Example: user-pass in builded image (uncomment for you custom setting):
    # && adduser -g wheel user1 \
    # && echo 'user1:pass1' | chpasswd \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    # SSH login fix. Otherwise user is kicked off after login
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && echo "export VISIBLE=now" >> /etc/profile \
    && ssh-keygen -A

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 22

CMD ["/usr/bin/supervisord"]
