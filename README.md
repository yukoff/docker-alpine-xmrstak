# alpine-xmrstak
[xmr-stak unified miner](https://github.com/fireice-uk/xmr-stak) in an Alpine Linux Docker container.

Using an [Alpine Linux](https://www.alpinelinux.org/) container gets you a very lightweight image of ~4MB and the benefits of Alpine Linux's security model.

This image is configured to run the miner as a dedicated restricted user. It is also configured to use environment variables as a corresponding parameter values and it is required to provide 2 pool urls.

## Usage

```bash
export POOL=...
export WALLET=...
export PASSWORD=...
export WORKERS=... # eg. number of CPU cores
docker run --restart unless-stopped --read-only -m 50M -c 512 yukoff/docker-alpine-xmrstak ${POOL} ${WALLET} ${PASSWORD} ${WORKERS}
```

### Docker Arguments

`--restart unless-stopped`

In case the miner crashes we want the docker service to restart it.

`--read-only`

This image does not need rw access. If there are bug/exploits in the pool/software you are a little bit more protected.

`-m 50M`

Restricts memory usage to 50MB.

`-c 512`

By default container will use <= half of system cores. Setting a relevant share count will protect you from a runaway process locking your system.

### `xmr-stak` Arguments

`--help`

All standard `xmr-stak` arguments are supported, using `--help` will list all of them.

```bash
docker run yukoff/docker-alpine-xmrstak --help
```

`-t`

When manually setting threads with `-t` you need to configure the correct CPU shares for docker.

IE if you have 4 cores, each core is worth 256 `(1024 / 4)`, so for miner to use 3 threads CPU shares for Docker must be set to 756:

```bash
docker run -c 756 yukoff/docker-alpine-xmrstak ... -t 3
```

## Donations

XMR: 4B7SeNuRh1eYPqdH1zRuPG9gKkJf3Fr4ZZR8LiV1W44cHVEyw9uqhMyYpj1EaYcqSZ4akCmMpL7bqUSbnrfQTZUYV1MErFW
