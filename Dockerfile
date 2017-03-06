FROM ubuntu:14.04
MAINTAINER Jeganathan Swaminathan <jegan@tektutor.org> <http://www.tektutor.org> 

RUN apt-get -y update && apt-get -y install ssh openssh-server 
RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd

# Add user "tektutor" with password "tektutor"
# Create an user named tektutor with admin privileges
RUN useradd -m -g sudo -p 'tektutor' tektutor 
# Set password for the tektutor user as tektutor 
RUN echo 'tektutor:tektutor' | chpasswd

# Disable root login &
# Disable password login, only allow public key. 
COPY sshd_config /etc/ssh/sshd_config
COPY sudoers /etc/sudoers

# Add sshd running directory.
RUN mkdir -m 755 /var/run/sshd

# Add ssh key directory.
RUN mkdir /home/tektutor/.ssh
RUN chown tektutor /home/tektutor/.ssh
COPY authorized_keys /home/tektutor/.ssh/authorized_keys

COPY sudoers /etc/sudoers

EXPOSE 22

# Launch SSH Server once the container is booted as a daemon
CMD ["/usr/sbin/sshd", "-D"]
