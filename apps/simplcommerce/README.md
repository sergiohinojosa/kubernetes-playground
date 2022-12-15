# The SimplCommerce NET Core App
A simple, cross platform, modularized ecommerce system built on .NET Core Join the chat at https://gitter.im/simplcommerce/SimplCommerce

The original repository can be found here:
https://github.com/simplcommerce/SimplCommerce
## Deploy & Undeploy the application
How to deploy
`bash deploy-simplcommerce.sh`

How to remove
`bash remove-simplecommerce.sh`

# SimplCommerce 
![SimplCommerce](../../doc/img/simplcommerce.png)

# PG Admin interface

![PG Admin](../../doc/img/pgadmin.png)

# Docker 
## Docker Compose with Simplcommerce, Postgres & PgAdmin 
So you can test docker compose, the images are already created. You only need `docker` and `docker-compose`.

## Docker-compose commands
> build the app with clean DB
docker-compose up 

Will spin up the application exposed at localhost:80
postgres at localhost:5432
pgadmin4 at localhost:443 credentials are user:pgadmin4@pgadmin.org pwd:admin (can be found in the docker compose file)


> In detached mode
docker-compose up -d

> Gracefully shutdown (persisting data)
docker-compose down

> Destroy data (clean DB) 
docker-compose down -v
