# docker-alp-couchpotato
Install Couchpotato into an Alpine Linux container


![couchpotato](https://couchpota.to/media/images/full.png)

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
      -p 5050:5050 digrouz/docker-alp-couchpotato

## Environment Variables

When you start the `couchpotato` image, you can adjust the configuration of the `couchpotato` instance by passing one or more environment variables on the `docker run` command line.

### `DOCKUID`

This variable is not mandatory and specifies the user id that will be set to run the application. It has default value `10009`.

### `DOCKGID`

This variable is not mandatory and specifies the group id that will be set to run the application. It has default value `10009`.


