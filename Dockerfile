FROM jenkins/inbound-agent as builder

FROM cloudbees/java-build-tools

COPY --from=builder /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-agent
COPY --from=builder /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

USER root

ARG user=jenkins

RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave
RUN chmod 644 /usr/share/jenkins/agent.jar \
      && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

USER ${user}
WORKDIR /home/jenkins

ENTRYPOINT ["/opt/bin/entry_point.sh", "jenkins-agent"]
