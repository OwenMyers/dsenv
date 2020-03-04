## To Build
First, log in to docker hub

```
docker login
```

Then you can build with something like

```
docker build \
    -t omyers/dsenv --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" \
    --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" ./
```

**Important note**: The way we are handling the github `ssh` credentials is not
safe in that the credentials will be in the built image. This is intentional.
By allowing credentials in the image we can have a much more practical
environment to work in. You can save an image and pass it around using `docker
save ...` and `docker load` to keep and full working environment with you.
Note that credentials will never be present in the repository itself. The repo
will be public and absent of sensitive material.

## To Run

```
docker run -it --mount type=bind,source="$(pwd)/scripts",target=/root/scripts \
    --mount type=bind,source=config/local.vim,target=/root/.config/nvim/config/local.vim \
    omyers/dsenv /bin/bash
```

