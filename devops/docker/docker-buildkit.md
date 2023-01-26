# Docker BuildKit

## Getting started

BuildKit is enabled by default for all users on Docker Desktop. If you have installed Docker Desktop, you don't have to manually enable BuildKit. if you are running Docker on Linux, you can enable BuildKit either by using an environment variable or by making BuildKit the default setting.

To see the BuildKit environment variable when running the `docker build` command, run:

```bash
$ DOCKER_BUILDKIT=1 docker build .    
```

> **Note**
>
> Buildx always enables BuildKit.

To enable docker BuildKit by default, set daemon configuration in `/etc/docker/daemon.json` feature to `true` and restart the daemon. If the `daemon.json` file doesn't exist, create new file called `daemon.json` and then add the following to the file.

```json
{
    "features" : {
        "buildkit" : true
    }
}
```

And restart the Docker daemon.

> **Warning**
>
> BuildKit only supports building Linux containers. Windows support is tracked in `moby/buildkit#616`





for more details : [https://docs.docker.com/build/buildkit/](https://docs.docker.com/build/buildkit/)

