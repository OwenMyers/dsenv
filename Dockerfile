FROM tensorflow/tensorflow:nightly

RUN apt-get update && \
    apt-get install -y git ninja-build gettext libtool libtool-bin autoconf \
    automake cmake g++ pkg-config unzip nodejs npm python3-venv

RUN git clone git@github.com:neovim/neovim.git && \
    cd neovim && sudo make CMAKE_BUILD_TYPE=Release && sudo make install

#RUN useradd -ms --disabled-password /bin/bash om && \
RUN adduser om --disabled-password && \
    usermod -aG sudo om
USER om
WORKDIR /home/om/
ENV PATH="$PATH:/home/om/.local/bin"

RUN pip install PyYAML && \
    pip install jupyterlab==1.2.6 neovim vim-vint pycodestyle pyflakes flake8 && \
    jupyter labextension install jupyterlab_vim 
    #python3 -m jupyter labextension install jupyterlab_vim

COPY placeinhome /home/om/
COPY scripts /home/om/scripts/

ARG ssh_prv_key
ARG ssh_pub_key

RUN git config --global user.name "owenmyers" && \
    git config --global user.email "owendalemyers@gmail.com"

# Authorize SSH Host
RUN mkdir -p /home/om/.ssh && \
    chmod 0700 /home/om/.ssh && \
    ssh-keyscan github.com > /home/om/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /home/om/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /home/om/.ssh/id_rsa.pub && \
    chmod 600 /home/om/.ssh/id_rsa && \
    chmod 600 /home/om/.ssh/id_rsa.pub

RUN git clone --depth 1 git://github.com/junegunn/fzf.git ~/.fzf && \
    cd /home/om/.fzf && ./install

RUN mkdir /home/om/.config && \
    git clone git://github.com/rafi/vim-config.git /home/om/.config/nvim && \
    cd /home/om/.config/nvim && \
    make test && make

COPY config/local.vim /home/om/.config/nvim/config/

RUN ln -s /usr/local/bin/python /usr/local/bin/python3 && \
    npm -g install neovim
