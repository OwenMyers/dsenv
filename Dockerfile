FROM tensorflow/tensorflow:latest

RUN apt-get update && \
    apt-get install -y git && \
    sudo apt-get install neovim

ARG ssh_prv_key
ARG ssh_pub_key

RUN git config --global user.name "owenmyers" && \
    git config --global user.email "owendalemyers@gmail.com"

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

RUN mkdir ~/.config && \
    git clone git://github.com/rafi/vim-config.git ~/.config/nvim && \
    cd ~/.config/nvim && \
    make 