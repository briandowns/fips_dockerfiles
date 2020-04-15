 
FROM gcr.io/google_containers/hyperkube:v1.17.4 as hyperkube
FROM briandowns/fips_kubernetes:latest          as source
FROM debian:buster                              as buster
FROM registry.access.redhat.com/ubi7/ubi:latest

RUN ln -s /hyperkube /apiserver                && \
    ln -s /hyperkube /cloud-controller-manager && \
    ln -s /hyperkube /controller-manager       && \
    ln -s /hyperkube /kubectl                  && \
    ln -s /hyperkube /kubelet                  && \
    ln -s /hyperkube /proxy                    && \
    ln -s /hyperkube /scheduler                && \
    ln -s /hyperkube /usr/local/bin/cloud-controller-manager

COPY --from=hyperkube /opt/cni/bin /opt/cni/bin
COPY --from=hyperkube /hyperkube /hyperkube
COPY --from=source /usr/local/bin/kube-apiserver /usr/local/bin/kube-apiserver 
COPY --from=source /usr/local/bin/kube-controller-manager /usr/local/bin/kube-controller-manager
COPY --from=source /usr/local/bin/kube-proxy /usr/local/bin/kube-proxy
COPY --from=source /usr/local/bin/kube-scheduler /usr/local/bin/kube-scheduler 
COPY --from=source /usr/local/bin/kubectl /usr/local/bin/kubectl 
COPY --from=source /usr/local/bin/kubelet /usr/local/bin/kubelet 

RUN rpm -Uhv http://download.ceph.com/rpm-jewel/el7/noarch/ceph-release-1-1.el7.noarch.rpm
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum update && yum upgrade -y && \
    yum install -y ca-certificates  \
    bash                            \
    socat                           \
    udev                            \
    zfsutils                        \
    wget                            \
    glusterfs-server                \
    glusterfs-client                \
    glusterfs-common                \
    samba                           \
    azure-cli                       \
    ceph-deploy                     \
    iscsi-initiator-utils           \
    git                             \
    e2fsprogs                       \
    xfsprogs                        \
    gnupg                           \
    conntrack                       \
    conntrack-tools                 \
    ebtables                        \
    ethtool                         \
    ipset                           \
    nfs-utils                       \
    curl                            \
    util-linux                      \
    iptables-services               \
    netbase

# RUN systemctl disable firewalld && \
#     systemctl enable iptables   && \
#     systemctl enable ip6tables
# RUN systemctl status iptables && \
#     systemctl status ip6tables

# Install other dependencies and then clean up apt caches
# RUN clean-install \
#     ipset         \
#     kmod          \
#     netbase

# Install iptables wrapper scripts to detect the correct iptables mode
# the first time any of them is run
# COPY --from=buster $(which iptables-wrapper) /usr/sbin/iptables-wrapper

# RUN update-alternatives                                                            \
#     --install /usr/sbin/iptables iptables /usr/sbin/iptables-wrapper 100           \
#     --slave /usr/sbin/iptables-restore iptables-restore /usr/sbin/iptables-wrapper \
#     --slave /usr/sbin/iptables-save iptables-save /usr/sbin/iptables-wrapper
# RUN update-alternatives                                                              \
#     --install /usr/sbin/ip6tables ip6tables /usr/sbin/iptables-wrapper 100           \
#     --slave /usr/sbin/ip6tables-restore ip6tables-restore /usr/sbin/iptables-wrapper \
#     --slave /usr/sbin/ip6tables-save ip6tables-save /usr/sbin/iptables-wrapper

ENTRYPOINT ["/hyperkube"]
