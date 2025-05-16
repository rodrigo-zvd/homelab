#!/bin/bash
mc alias set myminio http://minio:9000 root rootroot
mc mb -p myminio/terraform-state || true
mc admin user add myminio terraform terraform123
mc admin policy attach myminio readwrite --user terraform
