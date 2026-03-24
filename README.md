# SonosRB

A CLI tool for discovering and interacting with Sonos devices on your network.

## Build and run with Docker

```
docker build -t sonos_rb .
docker run -it --net=host sonos_rb
```

`--net=host` is required so the container can access your local network for Sonos device discovery.

## Running with Ruby

```
ruby sonos_rb.rb
```
