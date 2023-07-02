FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential sudo && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS prime
ARG TAGS
RUN addgroup --gid 1000 alex
RUN adduser --gecos alex --uid 1000 --gid 1000 --disabled-password alex
RUN echo "alex ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers  # add 'alex' user to sudoers
USER alex
WORKDIR /home/alex

FROM prime
COPY . .
CMD ["sh", "-c", "sudo ansible-playbook --vault-password-file vp.txt $TAGS dev-machine.yml"]
