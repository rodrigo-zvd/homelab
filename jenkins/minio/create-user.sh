#!/bin/sh

# Espera o MinIO iniciar
sleep 10

# Cria bucket, se não existir
mc alias set myminio http://localhost:9000 root rootroot
mc mb -p myminio/terraform-state || true

# Cria usuário
mc admin user add myminio terraform terraform123

# Anexa política de leitura e escrita ao usuário
mc admin policy attach myminio readwrite --user terraform
