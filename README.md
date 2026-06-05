# README

## Setup

```shell
docker compose run --rm app bin/rails db:prepare
```

## Run System

```shell
docker compose up app worker
```

## Run Ingest Process

```shell
docker compose run --rm app bin/ingest
```

## Run Test

```shell
docker compose run --rm test
```

## Verification

In addition to logging, there is simple index page that renders the ingested push event for verification [here](http://localhost:3000/).

