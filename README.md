# homelab

#env file
MINIO_ROOT_USER=
MINIO_ROOT_PASSWORD=
XCP_MASTER_IP=
XCP_USER=
XCP_PASSWORD=
JENKINS_ADMIN_USER=
JENKINS_ADMIN_PASSWORD=
XOA_USER=
XOA_PASSWORD=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
SSH_PUBLIC_KEY=
SSH_PRIVATE_KEY=

docker compose up -d --build --force-recreate

docker run --rm \
-v "$PWD:/work" \
-e MINIO_ACCESS_KEY \
-e MINIO_SECRET_KEY \
-e MINIO_ENDPOINT \
-e XOA_URL \
-e XOA_USER \
-e XOA_PASSWORD \
hairyhenderson/gomplate \
-f /work/backend.hcl.tpl -o /work/backend.hcl
 
docker run --rm \
-v "$PWD:/work" \
-e XOA_URL \
-e XOA_USER \
-e XOA_PASSWORD \
hairyhenderson/gomplate \
-f /work/terraform.tfvars.tpl -o /work/terraform.tfvars