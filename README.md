# docker-couchpotato
Install Couchpotato into a Linux container


![couchpotato](https://couchpota.to/media/images/full.png)

## Tags
Several tags are available:
* latest: see alpine3.6
* centos7: [centos7/Dokerfile](https://github.com/digrouz/docker-couchpotato/blob/centos7/Dockerfile)
* alpine3.6: [alpine3.6/Dockerfile](https://github.com/digrouz/docker-couchpotato/blob/alpine3.6/Dockerfile)


## Description

CouchPotato is an automatic NZB and torrent downloader. You can keep a "want to watch"-list and it will search for NZBs/torrents of these items every X hours. Once a correct release is found, matching the correct quality, it will send it to SABnzbd or download the. nzb or. torrent to a specified directory. Automatic downloading and sending of NZBs to SABnzbd. Automatic downloading of torrents files to a specified directory. Easily add movies via IMDB UserScript. Movie sorting and renaming. Quality options to download best available. Overwrite if better is found. 

https://couchpota.to/

## Usage
    docker create --name=couchpotato  \
      -v /etc/localtime:/etc/localtime:ro \
      -v <path to config>:/config \
      -v <path to downloads>:/downloads \
      -v <path to movies library>:/movies \
      -e DOCKUID=<UID default:10009> \
      -e DOCKGID=<GID default:10009> \
      -e DOCKUPGRADE=<0|1> \
      -p 5050:5050 digrouz/docker-alp-couchpotato

## Environment Variables

When you start the `couchpotato` image, you can adjust the configuration of the `couchpotato` instance by passing one or more environment variables on the `docker run` command line.

### `DOCKUID`

This variable is not mandatory and specifies the user id that will be set to run the application. It has default value `10009`.

### `DOCKGID`

This variable is not mandatory and specifies the group id that will be set to run the application. It has default value `10009`.

### `DOCKUPGRADE`

This variable is not mandatory and specifies if the container has to launch software update at startup or not. Valid values are `0` and `1`. It has default value `0`.

## Notes

* The docker entrypoint can upgrade operating system at each startup. To enable this feature, just add `-e DOCKUPGRADE=1` at container creation.

## Issues

If you encounter an issue please open a ticket at [github](https://github.com/digrouz/docker-couchpotato/issues)
