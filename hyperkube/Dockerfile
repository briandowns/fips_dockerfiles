 
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

ENTRYPOINT ["/hyperkube"]
