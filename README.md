## To Build
First, log in to docker hub

```
docker login
```

Then you can build with something like

```
docker build \
    -t omyers/dsenv --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" \
    --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" ./ \
```

Important note: the way we are handling the github `ssh` credentials is safe in
that the credentials will not be found in the image.

## To Run

```
docker run -it --mount type=bind,source="$(pwd)/scripts",target=/root/scripts \
    --mount type=bind,source=config/local.vim,target=/root/.config/nvim/config/local.vim \
    omyers/dsenv /bin/bash
```

