#!/bin/bash

# For developing purpouses how to mount OS directory as volume to docker container.
# docker run -v /Users/sergio.hinojosa/repos/kubernetes-playground/cluster-setup/resources/homepage/html/:/usr/share/nginx/html/ --name k8splaydev -p 80:80 -d nginx
# if NGINX throws 403 is a permission issue when cloning the repo. Give read rights to the html files recursively.

# Build tick tack toe and push it to the repository of microk8s
docker build  --platform linux/amd64 . -t shinojosa/k8splay:v0.4

# we push the image into the cluster repository
docker push shinojosa/k8splay:v0.4

