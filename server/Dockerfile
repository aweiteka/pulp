FROM fedora:20
MAINTAINER Aaron Weitekamp <aweiteka@redhat.com>

ADD fedora-pulp.repo /etc/yum.repos.d/fedora-pulp.repo

#RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# workaround: python-pulp-rpm-common not installed by groupinstall
RUN yum update -y && yum groupinstall -y pulp-server && yum install -y git && yum clean all

# config dir
#RUN mkdir /.pulp

# install pulp_docker plugin to manage docker image repositories
RUN cd /opt && git clone https://github.com/pulp/pulp_docker.git

RUN /opt/pulp_docker/manage_setup_pys.sh develop

ADD run.sh /run.sh
RUN chmod -v +x /run.sh

ENTRYPOINT ["/run.sh"]
# default parameter to run.sh
CMD ["worker"]
