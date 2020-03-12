FROM tensorflow/tensorflow:nightly

ARG ssh_prv_key
ARG ssh_pub_key

# We need to install sudo because the fzf install script uses it.
RUN apt-get update && \
    apt-get install -y git ninja-build gettext libtool libtool-bin autoconf \
    automake cmake g++ pkg-config unzip nodejs npm python3-venv sudo vim dos2unix && \
    rm -rf /var/lib/apt/lists/*

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

RUN git clone --depth 1 git://github.com/junegunn/fzf.git /root/.fzf && \
    cd /root/.fzf && sudo ./install

RUN git clone git@github.com:neovim/neovim.git /root/neovim && \
    cd /root/neovim && \
    make CMAKE_BUILD_TYPE=Release && \
    make CMAKE_INSTALL_PREFIX=/usr/local/bin/nvim install

ENV PATH="$PATH:/root/.local/bin"

RUN pip install PyYAML
RUN pip install jupyterlab==1.2.6 neovim vim-vint pycodestyle pyflakes flake8
    #python3 -m jupyter labextension install jupyterlab_vim

RUN git config --global user.name "owenmyers" && \
    git config --global user.email "owendalemyers@gmail.com" && \
    git config --global core.autocrlf true

# Authorize SSH Host
COPY placeinhome /root/
RUN dos2unix root/*
COPY scripts /root/scripts/
RUN dos2unix root/scripts/*

RUN jupyter labextension install jupyterlab_vim 

RUN mkdir /root/.config && \
    git clone git://github.com/rafi/vim-config.git /root/.config/nvim  && \
    cd /root/.config/nvim && \
    make test && make

COPY config/local.vim /root/.config/nvim/config/
RUN dos2unix /root/.config/nvim/config/*

#RUN ln -s /usr/local/bin/python /usr/local/bin/python3 && \
#    npm -g install neovim
