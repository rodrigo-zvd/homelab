#!/bin/bash
docker exec -it jenkins-minio-1 mc alias set myminio http://localhost:9000 root rootroot
docker exec -it jenkins-minio-1 mc mb -p myminio/terraform-state || true
docker exec -it jenkins-minio-1 mc admin user add myminio terraform terraform123
docker exec -it jenkins-minio-1 mc admin policy attach myminio readwrite --user terraform
