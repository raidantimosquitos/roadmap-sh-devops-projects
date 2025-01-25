# Basic Dockerfile

Writing a basic Dockerfile to create a Docker image. When running this Docker image, it should print "Hello, Captain [YOUR_NAME]!" to the console before exiting. This is my implementation of [roadmap.sh](https://roadmap.sh/projects/basic-dockerfile) project.

## Table of contents
- [Requirements](#requirements)
- [Usage](#usage)
- [Dockerfile insights](#dockerfile-insights)

## Requirements
You must have Docker installed in your OS in order to run this project. To do so, you can follow the instructions on this [link](https://docs.docker.com/get-started/get-docker/).

## Usage
First you must build the Docker image (Alpine Linux in this case). To do so, execute the following command from the root directory of this project:
```bash
docker build -t hello-captain .
```
***Note**: You can change the name of your image to whatever you like (in my case is hello-captain).*

Second and lastly, you can run the created image by using the following command:
```bash
docker run -e YOUR_NAME="Fulano Mengano" hello-captain
```

***Note**: You can assign the value of your preference to the YOUR_NAME environment variable.*

## Dockerfile insights
Let's take a brief look to the simple `Dockerfile` used to build and run this Docker image.

```dockerfile
ARG IMG_VERSION=latest
FROM alpine:${IMG_VERSION}

# Pass YOUR_NAME as an environment variable
ENV YOUR_NAME="Fulano"

# Use JSON array for CMD to prevent shell signal issues
CMD ["sh", "-c", "echo \"Hello, Captain $YOUR_NAME!\""]
```

The first two lines of the docker file are responsible for building the Docker image. A build argument named `IMG_VERSION` is provided to allow the user to use a specific Alpine linux base-image version, though by default is assigned to the latest one. To do so, the `docker build` command could be updated as follows:

```bash
docker build --build-arg IMG_VERSION=3.17 -t hello-captain .
```

The last two lines define the execution of the containerized application, that is printing 'Hello, captain [YOUR_NAME]!' in the console. The `YOUR_NAME` environment variable can be specified at the time of running the `docker run` command, as indicated in the previous section. If no value is specified, the default `Fulano` value is used.

JSON syntax for running shell commands is preferred, this is because:
- Shell commands like `CMD echo ...` invoke a shell implicitly (e.g., `/bin/sh -c`), which can cause unintended behavior.
- Explicit JSON syntax, like `CMD ["sh", "-c", "..."]`, avoids ambiguity.
