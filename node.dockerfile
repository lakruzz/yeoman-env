# Use the official node lts image
FROM node:lts-bullseye

# Set working directory
WORKDIR /workspace

# Create a non-root user
RUN useradd -m youser && echo "youser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

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