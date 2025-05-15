# Base image
FROM ronivay/xen-orchestra:latest

# Switch to root to install dependencies
USER root

RUN npm install --global xo-cli

RUN xo-cli register --allowUnauthorized http://localhost admin@admin.net admin

RUN xo-cli server.add host=${XCP_MASTER_IP} username="${XCP_USER}" password="${XCP_PASSWORD}" autoConnect=true allowUnauthorized=true
