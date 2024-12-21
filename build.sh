#!/bin/bash

set -ex

VERSION=$1
IMAGE_NAME="networknt/portal-hybrid-command"
LOCAL_BUILD=false # Flag to track local build

showHelp() {
    echo " "
    echo "Error: $1"
    echo " "
    echo "    build.sh [VERSION] [-l|--local]"
    echo " "
    echo "    where [VERSION] version of the docker image that you want to publish (example: 0.0.1)"
    echo "          [-l|--local] optional flag to only build the docker image locally"
    echo " "
    echo "    example: ./build.sh 0.0.1"
    echo "    example: ./build.sh 0.0.1 -l"
    echo " "
}

build() {
    echo "Building ..."
    mvn clean install -Prelease
    echo "Successfully built!"
}

cleanup() {
    if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" != "" ]]; then
        echo "Removing old $IMAGE_NAME images"
        docker images | grep $IMAGE_NAME | awk '{print $3}' | xargs docker rmi -f
        echo "Cleanup completed!"
    fi
}

publish() {
    echo "Building Docker image with version $VERSION"
    docker build -t $IMAGE_NAME:$VERSION -t $IMAGE_NAME:latest -f ./docker/Dockerfile . --no-cache=true
    docker build -t $IMAGE_NAME:$VERSION-slim -f ./docker/Dockerfile-Slim . --no-cache=true
    echo "Images built with version $VERSION"

    if $LOCAL_BUILD; then
      echo "Skipping DockerHub publish due to local build flag (-l or --local)"
    else
      echo "Pushing image to DockerHub"
      docker push $IMAGE_NAME -a
      echo "Image successfully published!"
    fi
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -l|--local)
      LOCAL_BUILD=true
      shift
      ;;
    *)
      if [ -z "$VERSION" ]; then
        VERSION="$1"
      else
        showHelp "Invalid option: $1"
        exit 1
      fi
      shift
      ;;
  esac
done


if [ -z "$VERSION" ]; then
    showHelp "[VERSION] parameter is missing"
    exit 1
fi

build;
cleanup;
publish;
