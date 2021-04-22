#!/bin/bash

if [ ! -d docs ]; then
  echo "pulling docker image"
  docker pull squidfunk/mkdocs-material

  echo "initializing docs"
  mkdir docs

  docker run --rm -it -p 8000:8000 \
    -v ${PWD}:/docs squidfunk/mkdocs-material new .
else
  echo "running mkdocs @ 127.0.0.1:8000" 
  docker run --rm -it -p 8000:8000 \
    -v ${PWD}:/docs squidfunk/mkdocs-material
fi
