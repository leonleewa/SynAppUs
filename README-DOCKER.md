# SynAppUs Bot - Docker Deployment Guide

This guide explains how to build and deploy the SynAppUs Bot website using Docker.

## Prerequisites

- Docker installed (version 20.10 or later)
- Docker Compose installed (version 1.29 or later)
- Basic knowledge of Docker commands

## Project Structure

```
Synapp.us/
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Docker Compose configuration
├── nginx.conf             # Nginx web server configuration
├── .dockerignore          # Files to exclude from Docker build
└── Synapp.us_Updated/     # Website source files
    ├── index.html
    ├── pricing.html
    ├── contacts.html
    └── images/
```

## Quick Start

### 1. Build and Run Locally with Docker Compose

```bash
# Build and start the container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

The website will be available at: http://localhost:8080

### 2. Build Docker Image Manually

```bash
# Build the image
docker build -t synappus-bot:latest .

# Run the container
docker run -d -p 8080:80 --name synappus-website synappus-bot:latest

# View logs
docker logs -f synappus-website

# Stop and remove container
docker stop synappus-website
docker rm synappus-website
```

## Cloud Deployment

### Deploy to Docker Hub

```bash
# Login to Docker Hub
docker login

# Tag your image
docker tag synappus-bot:latest yourusername/synappus-bot:latest

# Push to Docker Hub
docker push yourusername/synappus-bot:latest
```

### Deploy to AWS ECR (Elastic Container Registry)

```bash
# Authenticate Docker to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws-account-id>.dkr.ecr.us-east-1.amazonaws.com

# Create ECR repository (first time only)
aws ecr create-repository --repository-name synappus-bot --region us-east-1

# Tag image for ECR
docker tag synappus-bot:latest <aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/synappus-bot:latest

# Push to ECR
docker push <aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/synappus-bot:latest
```

### Deploy to Google Container Registry (GCR)

```bash
# Configure Docker to use gcloud
gcloud auth configure-docker

# Tag image for GCR
docker tag synappus-bot:latest gcr.io/<project-id>/synappus-bot:latest

# Push to GCR
docker push gcr.io/<project-id>/synappus-bot:latest
```

### Deploy to Azure Container Registry (ACR)

```bash
# Login to ACR
az acr login --name <registry-name>

# Tag image for ACR
docker tag synappus-bot:latest <registry-name>.azurecr.io/synappus-bot:latest

# Push to ACR
docker push <registry-name>.azurecr.io/synappus-bot:latest
```

## Production Deployment Options

### Option 1: AWS ECS (Elastic Container Service)

1. Push image to ECR (see above)
2. Create ECS Cluster
3. Create Task Definition with your image
4. Create Service with load balancer
5. Configure domain and SSL certificate

### Option 2: Google Cloud Run

```bash
# Deploy directly from source
gcloud run deploy synappus-bot \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated

# Or deploy from GCR
gcloud run deploy synappus-bot \
  --image gcr.io/<project-id>/synappus-bot:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### Option 3: Azure Container Instances

```bash
# Deploy from ACR
az container create \
  --resource-group myResourceGroup \
  --name synappus-website \
  --image <registry-name>.azurecr.io/synappus-bot:latest \
  --dns-name-label synappus-bot \
  --ports 80
```

### Option 4: DigitalOcean App Platform

1. Push image to Docker Hub
2. Create new App in DigitalOcean
3. Select "Docker Hub" as source
4. Enter your image: `yourusername/synappus-bot:latest`
5. Configure domain and deploy

### Option 5: Kubernetes (Any Cloud)

Create a deployment file `k8s-deployment.yml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: synappus-website
spec:
  replicas: 2
  selector:
    matchLabels:
      app: synappus-website
  template:
    metadata:
      labels:
        app: synappus-website
    spec:
      containers:
      - name: synappus-website
        image: synappus-bot:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: synappus-website
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: synappus-website
```

Deploy:
```bash
kubectl apply -f k8s-deployment.yml
```

## Environment Configuration

### Custom Port

Change the port mapping in `docker-compose.yml`:

```yaml
ports:
  - "3000:80"  # Change 3000 to your desired port
```

### Production Environment Variables

For production, you may want to add environment variables:

```yaml
environment:
  - NGINX_HOST=synapp.us
  - NGINX_PORT=80
```

## SSL/TLS Configuration

For production with HTTPS, consider using:

1. **Reverse Proxy**: Place nginx or Traefik in front with Let's Encrypt
2. **Cloud Load Balancer**: Use cloud provider's load balancer with SSL termination
3. **Cloudflare**: Put your site behind Cloudflare for free SSL

Example with Traefik:

```yaml
version: '3.8'

services:
  traefik:
    image: traefik:v2.10
    command:
      - "--providers.docker=true"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.myresolver.acme.tlschallenge=true"
      - "--certificatesresolvers.myresolver.acme.email=admin@synapp.us"
      - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "./letsencrypt:/letsencrypt"

  synappus-web:
    image: synappus-bot:latest
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.synappus.rule=Host(`synapp.us`)"
      - "traefik.http.routers.synappus.entrypoints=websecure"
      - "traefik.http.routers.synappus.tls.certresolver=myresolver"
```

## Monitoring and Maintenance

### View Container Logs

```bash
# Using Docker Compose
docker-compose logs -f synappus-web

# Using Docker
docker logs -f synappus-website
```

### Check Container Health

```bash
# Check status
docker ps

# Inspect health check
docker inspect --format='{{.State.Health.Status}}' synappus-website
```

### Update Deployment

```bash
# Pull latest changes
git pull

# Rebuild and restart
docker-compose up -d --build

# Or manually
docker build -t synappus-bot:latest .
docker-compose down
docker-compose up -d
```

## Troubleshooting

### Container won't start

```bash
# Check logs
docker-compose logs synappus-web

# Check nginx configuration
docker-compose exec synappus-web nginx -t
```

### Port already in use

Change the port in `docker-compose.yml` or stop the conflicting service:

```bash
# Find process using port 8080
netstat -ano | findstr :8080  # Windows
lsof -i :8080                 # Linux/Mac

# Stop the process or change docker-compose.yml port
```

### Permission issues

```bash
# Rebuild with no cache
docker-compose build --no-cache

# Check file permissions in container
docker-compose exec synappus-web ls -la /usr/share/nginx/html
```

## Image Size Optimization

Current image is based on `nginx:alpine` which is ~40MB. Already optimized!

To further reduce size:
- Remove unused images from `Synapp.us_Updated/images/`
- Compress images before building
- Use `.dockerignore` effectively (already configured)

## Security Best Practices

1. **Don't run as root**: Already configured in nginx:alpine
2. **Security headers**: Configured in `nginx.conf`
3. **Regular updates**: Update base image regularly
   ```bash
   docker pull nginx:alpine
   docker-compose build --pull
   ```
4. **Scan for vulnerabilities**:
   ```bash
   docker scan synappus-bot:latest
   ```

## Backup and Restore

### Backup

```bash
# Save image
docker save synappus-bot:latest | gzip > synappus-bot-backup.tar.gz

# Export volume (if using volumes)
docker run --rm -v synappus_data:/data -v $(pwd):/backup alpine tar czf /backup/data-backup.tar.gz /data
```

### Restore

```bash
# Load image
docker load < synappus-bot-backup.tar.gz

# Import volume (if using volumes)
docker run --rm -v synappus_data:/data -v $(pwd):/backup alpine tar xzf /backup/data-backup.tar.gz -C /
```

## Support

For issues or questions:
- Check container logs: `docker-compose logs`
- Verify nginx config: `docker-compose exec synappus-web nginx -t`
- Check Docker documentation: https://docs.docker.com

## License

Copyright 2025 SynAppUs Bot. All rights reserved.
