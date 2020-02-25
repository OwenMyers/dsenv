To build 

```
docker build 
    -t omyers/dsenv --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" \
    --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"
```

Important note: the above is a secure way to handle the github `ssh` credentials.