# Viztube

## Setup

You need to setup some vars in

## Docker

We Use 2 images: dev & prod. Dev image is used for development & testing, while prod is deployed.

To build dev image:

    docker-compose build

To run only modified test:

    docker-compose up
    docker-compose exec viztube env MIX_ENV=test mix test --color --stale

You can create your own dev image also:

    docker build -t viztube:dev -f docker/Dockerfile.dev .

### Build release

We are using Distillery & Docker multi-stage.

    docker build -t viztube:build -f Dockerfile.multistage .

It can be tested with:

       docker run -it --rm -p 4000:4000 -e "HOST=localhost" -e "SECRET_KEY_BASE=MPyVFpBIthyGt1ZsfsCgvF0z32RHe3jFulOx2lkjq0L5M9/AIqexgcVnQe5OUyeM" -e "DB_USERNAME=postgres" -e "DB_PASSWORD=postgres" -e "DB_NAME=viztube_dev" -e "DB_HOSTNAME=172.17.0.1" viztube:release /app/bin/viztube_umbrella foreground

## Environment variables

You must to set:

``$SECRET_KEY_BASE`` in order to generate secrets. This can be generated using `mix phx.gen.secret`

``$GUARDIAN_SECRET_KEY`` Secret key for authentication. This can be generated using `mix guardian.gen.secret`

### Email login link

You should set:

``$SMTP_USERNAME``, ``$SMTP_PASSWORD``, ``$SMTP_HOSTNAME``, environment variable for smtp server configuration.

``$EXT_HOST`` environment variable for %URL{} struct in login link

### Youtube

``$YT_API_KEY`` is the youtube api key
## Deploy

Helm is used for deployment to prod.
A deployment is identify by chart/viztube/viztube-deployment.yaml where file name will be a k8s namespace

you need to store secrets in k8s namespace.


    db-hostname
    db-username
    db-password
    db-name
    secret-key-base
    guardian-secret-key
    smtp-hostname
    smtp-username
    smtp-password
    yt-api-key


then

    helm install --name=viztube-deployment --debug --wait --namespace=viztube-deployment -f chart/viztube/viztube-deployment.yaml chart/viztube


## License

This repository is under Apache license: https://www.apache.org/licenses/LICENSE-2.0
