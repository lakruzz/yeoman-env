# Use the official Ubuntu base image
FROM ubuntu:24.04

# Set working directory
WORKDIR /workspace


# Update package lists and install necessary packages (nodejs is included in the ubuntu image)
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    npm

# Create a non-root user
RUN apt-get install -y sudo
RUN useradd -m youser && \
    echo "youser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    usermod -aG sudo youser

# Install Yeoman and the specific generators
RUN npm install -g yo \
   generator-office \
   generator-fountain-webapp 
   

# Set PATH to include npm global directories
ENV PATH="/usr/local/bin:/usr/local/lib/node_modules/.bin:${PATH}"

# Change owner of npm directories to the non-root user
RUN chown -R youser:$(id -gn youser) /usr/local/lib/node_modules

# Switch to the non-root user
USER youser


# Expose port (if needed)
EXPOSE 3000

# Entry point to run yo with passed arguments
ENTRYPOINT ["yo"]