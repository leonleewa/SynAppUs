# SynAppUs Bot

**Smart Telegram group management — from thousands of clicks to just a few.**

## About

SynAppUs Bot is a comprehensive solution for managing Telegram groups and channels. It provides centralized management, secure authentication, and CRM integration to streamline communication workflows.

## Features

- 🔧 **Group & Channel Manager** - Manage all your Telegram groups from a single dashboard
- 🔐 **Single Sign-On (SSO)** - Secure, unified access with identity management
- 🤝 **CRM Integration** - Seamlessly connect with HubSpot, Salesforce, and other platforms

## Website

This repository contains the marketing website for SynAppUs Bot.

**Live Site:** https://synapp.us

**Pages:**
- **Home** (`index.html`) - Overview and feature showcase
- **Pricing** (`pricing.html`) - Service plans and pricing
- **Contacts** (`contacts.html`) - Get in touch

## Technology Stack

- HTML5, CSS3, JavaScript
- Tailwind CSS
- Nginx web server
- Docker containerization

## Quick Start

### Local Development

```bash
# Serve with any static server
python -m http.server 8000 -d site
# or
npx serve site
```

### Docker Deployment

```bash
docker-compose up -d
```

Visit: http://localhost:8080

For detailed deployment options (AWS, GCP, Azure), see [README-DOCKER.md](README-DOCKER.md).

## Project Structure

```
├── site/                  # Website source files
│   ├── index.html        # Home page
│   ├── pricing.html      # Pricing page
│   ├── contacts.html     # Contact page
│   └── images/           # Image assets
├── docker-compose.yml    # Docker Compose config
├── Dockerfile            # Docker image definition
└── nginx.conf            # Nginx configuration
```

## Additional Documentation

- [Docker Deployment Guide](README-DOCKER.md) - Comprehensive deployment instructions
- [Google Sheets Setup](GOOGLE-SHEETS-SETUP.md) - Contact form integration
- [Quick Setup Reference](QUICK-SETUP-REFERENCE.md) - Fast deployment guide

## License

© 2025 SynAppUs Bot. All rights reserved.

## Contact

Visit our [contact page](https://synapp.us/contacts.html) to get in touch.
