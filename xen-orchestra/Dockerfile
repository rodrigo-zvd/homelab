# Base image
FROM ronivay/xen-orchestra:latest

# Switch to root to install dependencies
USER root

# Install xen orchestrs command line (xo-cli)
RUN npm install --global xo-cli

# Install jq
RUN apt update && apt install jq -y



