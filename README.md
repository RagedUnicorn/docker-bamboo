# docker-bamboo

> A docker base image to build a container for Bamboo based on Alpine Linux

This container is intended to build a base for running Bamboo Software.

## Using the image

#### Start container

The container can be easily started with `docker-compose` command.

```
docker-compose up -d
```

Once the container is running navigate to http://[dockerhost]:8085 to finish the configuration.

#### Stop container

To stop all services from the docker-compose file

```
docker-compose down
```

#### Join a swarm

```
docker swarm init
```

#### Create secrets
```
echo "app_user" | docker secret create com.ragedunicorn.postgresql.app_user -
echo "app_user_password" | docker secret create com.ragedunicorn.postgresql.app_user_password -
```

#### Deploy stack
```
docker stack deploy --compose-file=docker-compose.stack.yml [stackname]
```

For a production deployment a stack should be deployed. The secrets will then be taken into account and postgresql will be setup accordingly. The new app user will be configured for external access to the database.

## Dockery

In the dockery folder are some scripts that help out avoiding retyping long docker commands but are mostly intended for playing around with the container. For production use docker-compose should be used.

#### Build image

The build script builds an image with a defined name

```
sh dockery/dbuild.sh
```

#### Run container

Runs the built container. If the container was already run once it will `docker start` the already present container instead of using `docker run`

```
sh dockery/drun.sh
```

#### Attach container

Attaching to the container after it is running

```
sh dockery/dattach.sh
```

#### Stop container

Stopping the running container

```
sh dockery/dstop.sh
```

## Configuration

#### Build Args

The image allows for certain arguments being overridden by build args.

`BAMBOO_USER, BAMBOO_GROUP`

They all have a default value and don't have to be overridden. For details see the Dockerfile.

## Persistence

The container is storing data in the docker volume configured by the environment variable `${BAMBOO_DATA_DIR}` and `${BAMBOO_LOGS_DIR}`.

## Healthcheck

The production and the stack image supports a simple healthcheck showing whether the container is healthy or not. This can be configured inside `docker-compose.yml` or `docker-compose.stack.yml`

## Test

To do basic tests of the structure of the container use the `docker-compose.test.yml` file.

`docker-compose -f docker-compose.test.yml up`

For more info see [container-test](https://github.com/RagedUnicorn/docker-container-test).

Tests can also be run by category such as command, fileExistence and metadata tests by starting single services in `docker-compose.test.yml`

```
# basic file existence tests
docker-compose -f docker-compose.test.yml up container-test
# command tests
docker-compose -f docker-compose.test.yml up container-test-command
# metadata tests
docker-compose -f docker-compose.test.yml up container-test-metadata
```

The same tests are also available for the `dev-image`

```
# basic file existence tests
docker-compose -f docker-compose.test.yml up container-dev-test
# command tests
docker-compose -f docker-compose.test.yml up container-dev-test-command
# metadata tests
docker-compose -f docker-compose.test.yml up container-dev-test-metadata
```

## Development

To debug the container and get more insight into the container use the `docker-compose.dev.yml` configuration.

```
docker-compose -f docker-compose.dev.yml up -d
```

By default the launchscript `/docker-entrypoint.sh` will not be used to start the Bamboo process. Instead the container will be setup to keep `stdin_open` open and allocating a pseudo `tty`. This allows for connecting to a shell and work on the container. A shell can be opened inside the container with `docker attach [container-id]`. Bamboo itself can be started with `./docker-entrypoint.sh`.

## Links

Alpine packages database
- https://pkgs.alpinelinux.org/packages

## License

Copyright (C) 2019 Michael Wiesendanger

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
