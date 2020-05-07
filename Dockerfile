FROM alpine.base
RUN apk update && apk upgrade && apk add --no-cache openssh openrc && rc-update add sshd && \  
    # 設定 OpenSSH
    mkdir /run/openrc && touch /run/openrc/softlevel && rc-status &>/dev/null && \
    # 建立 sshup
    echo '#!/bin/bash' > /usr/bin/sshup && echo -e 'Welcome to Alpine 3.10.1\n' > /etc/motd && \ 
    #echo '/etc/init.d/sshd start &>/dev/null && tail -f /dev/null' >> /usr/bin/sshup && chmod +x /usr/bin/sshup && \
    # 建立管理者帳號 bigred   
        rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key && \
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
        ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && \
    adduser -s /bin/bash -h /home/bigred -G wheel -D bigred && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo -e "bigred\nbigred\n" | passwd bigred &>/dev/null && [ "$?" == "0" ] && echo "bigred ok"

ENTRYPOINT ["/usr/sbin/sshd", "-D"]

