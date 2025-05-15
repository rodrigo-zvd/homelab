# Base image
FROM ronivay/xen-orchestra:latest

# Switch to root to install dependencies
USER root

RUN npm install --global xo-cli


# docker exec -it jenkins-xen-orchestra-1 xo-cli register --allowUnauthorized http://localhost admin@admin.net admin && xo-cli server.add host=${XCP_MASTER_IP} username="${XCP_USER}" password="${XCP_PASSWORD}" autoConnect=true allowUnauthorized=true
