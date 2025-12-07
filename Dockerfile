# Multi-stage build for optimized image size
FROM nginx:alpine

# Set maintainer label
LABEL maintainer="SynAppUs <admin@synapp.us>"
LABEL description="SynAppUs Bot - Static Website"

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy website files
COPY Synapp.us_Updated/ /usr/share/nginx/html/

# Set proper permissions
RUN chmod -R 755 /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
