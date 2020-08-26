FROM quay.io/openshifthomeroom/workshop-dashboard:latest

USER root

RUN echo 'default ALL=(ALL) NOPASSWD: ALL' | EDITOR='tee -a' visudo

RUN curl -s -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.4/linux/oc.tar.gz && \
   tar -C /usr/local/bin -zxf /tmp/oc.tar.gz oc && \
   mv /usr/local/bin/oc /usr/local/bin/oc-4.4 && \
   ln -s /usr/local/bin/oc-4.4 /usr/local/bin/kubectl-1.17 && \
   rm /tmp/oc.tar.gz && \
   curl -s -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.5/linux/oc.tar.gz && \
   tar -C /usr/local/bin -zxf /tmp/oc.tar.gz oc && \
   mv /usr/local/bin/oc /usr/local/bin/oc-4.5 && \
   ln -s /usr/local/bin/oc-4.5 /usr/local/bin/kubectl-1.18
RUN wget https://github.com/noobaa/noobaa-operator/releases/download/v2.3.0/noobaa-linux-v2.3.0 -O /usr/bin/noobaa
RUN chmod +x /usr/bin/noobaa

COPY . /tmp/src

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src

USER 1001

RUN /usr/libexec/s2i/assemble
