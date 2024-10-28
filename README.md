# Arch Linux (Docker Container on GCP)

![Banner Image](https://raw.githubusercontent.com/thehackersbrain/archvnc/refs/heads/main/screenshots/archvnc.png)

- On GCP Console
```bash
git clone https://github.com/thehackersbrain/archvnc.git && cd archvnc
docker build -t archvnc .
docker run --network host -d archvnc
```

- For stopping the docker image
```bash
docker ps # for getting all running containers
docker stop <image-id> # for stopping the image
# or
docker kill <image-id> # for graceful killing image
```

- On VNCView Machine
```bash
vncviewer <ip>:1
```
> `:1` is for 5901 and display `:1` and the default password is `hacker101`
