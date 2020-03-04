FROM tensorflow/tensorflow:nightly

RUN apt-get update && \
    apt-get install -y git ninja-build gettext libtool libtool-bin autoconf \
    automake cmake g++ pkg-config unzip nodejs npm

RUN pip install PyYAML && \
    pip install jupyterlab==1.2.6 && \
    jupyter labextension install jupyterlab_vim
    #python3 -m jupyter labextension install jupyterlab_vim

COPY placeinhome /root/
COPY scripts /root/scripts/

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

RUN git clone git@github.com:neovim/neovim.git && \
    cd neovim && make && make install

RUN git clone --depth 1 git://github.com/junegunn/fzf.git ~/.fzf && \
    cd ~/.fzf && ./install

RUN mkdir ~/.config && \
    git clone git://github.com/rafi/vim-config.git ~/.config/nvim && \
    cd ~/.config/nvim && \
    make test && make

RUN rm -rf /root/.ssh

COPY config/local.vim /root/.config/nvim/config/
