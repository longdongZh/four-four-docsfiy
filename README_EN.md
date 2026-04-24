# FourFour Docsify

A lightweight static documentation site built with [Docsify](https://docsify.js.org/#/?id=docsify), supporting Docker containerized deployment.

## Table of Contents

- [Introduction](#introduction)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
  - [Method 1: Docker Deployment (Recommended)](#method-1-docker-deployment-recommended)
  - [Method 2: Local Development](#method-2-local-development)
- [Live Preview & Auto Reload](#live-preview--auto-reload)
  - [Auto Reload in Docker Environment](#auto-reload-in-docker-environment)
  - [Auto Reload in Local Development](#auto-reload-in-local-development)
- [Environment Variables](#environment-variables)
- [Project Structure](#project-structure)
- [Common Commands](#common-commands)
- [Advanced Configuration](#advanced-configuration)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Introduction

This is a lightweight documentation site built with Docsify. Features include:

- ✅ Markdown documentation
- ✅ Full-text search
- ✅ Code highlighting and copying
- ✅ Image zoom
- ✅ Sidebar collapse
- ✅ PDF embedding
- ✅ Draw.io diagrams
- ✅ Comment system (Valine)
- ✅ Visit statistics
- ✅ Docker containerized deployment
- ✅ **Live preview with auto reload**

## Tech Stack

- **Docsify** - Dynamic documentation website generator
- **Nginx** - Web server
- **Docker** - Containerized deployment
- **Vue.js** - Frontend framework

## Quick Start

### Method 1: Docker Deployment (Recommended)

#### 1. Clone the project

```bash
git clone <your-repo-url>
cd fourfour-docsfiy
```

#### 2. Configure environment variables

Copy the environment variable example file:

```bash
cp .env.example .env
```

Edit the `.env` file and modify configurations according to your needs:

```env
DOCSIFY_NAME=FourFour Docsify
DOCSIFY_VERSION=2.20.1
DOCSIFY_BASE_PATH=docs/
AUTH_ENABLE=true
# ... other configurations
```

#### 3. Build and start

```bash
docker-compose up -d
```

#### 4. Access the documentation

Open your browser and visit: http://localhost:3000

#### 5. View logs

```bash
docker-compose logs -f
```

#### 6. Stop the service

```bash
docker-compose down
```

### Method 2: Local Development

#### Prerequisites

- Node.js >= 14.x
- npm or yarn

#### 1. Install dependencies

```bash
npm install -g docsify-note-cli
```

#### 2. Start local server

```bash
docsify s
```

#### 3. Access the documentation

Open your browser and visit: http://localhost:3000

## Live Preview & Auto Reload

### Auto Reload in Docker Environment

The project has built-in file watching and auto reload functionality. No need to manually refresh the browser after modifying documents.

#### Enable Auto Reload

1. Edit the `.env` file and set `AUTO_RELOAD=true`:

```env
AUTO_RELOAD=true
```

2. Restart the container to apply the configuration:

```bash
docker-compose down
docker-compose up -d
```

3. Check logs to confirm auto reload is enabled:

```bash
docker-compose logs docs
```

You should see output like:
```
Starting Docsify with auto-reload...
Auto-reload is enabled. Watching for file changes...
File watcher started with PID: xxx
```

#### How It Works

- **File Watcher**: Checks for Markdown file changes every 1 second inside the container
- **Browser Detection**: Frontend script checks `index.html` Last-Modified header every 1 second
- **Auto Reload**: Automatically forces browser refresh when changes are detected
- **Trigger Mechanism**: File watcher updates `index.html` modification time via `touch` when `.md` files change

#### Usage Flow

```bash
# 1. Edit document
vim docs/README.md

# 2. Save file

# 3. Browser automatically refreshes to show latest content (no action needed)
```

#### Notes

- ✅ Only automatically enabled in `localhost` or `127.0.0.1` environment
- ✅ Recommended to disable in production (`AUTO_RELOAD=false`)
- ✅ Minimal performance impact (checks every 1 second)
- ✅ Requires modern browser with Fetch API support
- ✅ Shows "Auto-reload enabled for development" in console on first load
- ✅ Displays old and new Last-Modified values when changes are detected

#### Verify Auto Reload

1. **Check container logs**:
   ```bash
   docker-compose logs docs | grep -i "auto-reload\|watcher\|detected"
   ```
   You should see:
   ```
   Auto-reload is enabled. Watching for file changes...
   File watcher started with PID: xxx
   ```

2. **Open browser console** (F12 → Console):
   - Should see: `Auto-reload enabled for development`
   - Should see: `Initial Last-Modified: ...`

3. **Test by editing document**:
   ```bash
   vim docs/README.md
   # Add content and save
   ```
   
4. **Observe three places**:
   - **Container logs**: `Detected changes in markdown files, triggering reload...`
   - **Browser console**: `Page updated, reloading...` + timestamp comparison
   - **Browser page**: Automatically refreshes to show latest content

5. **If not working, check**:
   ```bash
   # Confirm environment variable
   docker-compose exec docs env | grep AUTO_RELOAD
   
   # Check file watcher
   docker-compose exec docs ps aux | grep "while true"
   
   # Manual trigger test
   docker-compose exec docs touch /usr/share/nginx/html/index.html
   ```

### Auto Reload in Local Development

When using `docsify s` command to start the local development server, you also need to handle browser caching issues.

#### Method 1: Disable Browser Cache (Recommended)

1. Open browser developer tools (F12)
2. Click **Network** tab
3. Check **Disable cache**
4. Keep developer tools open
5. Refresh the page after modifying files to see updates

#### Method 2: Force Refresh

- **Windows/Linux**: `Ctrl + Shift + R` or `Ctrl + F5`
- **macOS**: `Cmd + Shift + R`

#### Method 3: Use Auto Refresh Extensions

Install browser extensions:
- **LiveReload** (Chrome/Firefox)
- **Auto Refresh Plus**

## Environment Variables

| Variable | Default Value | Description |
|----------|--------------|-------------|
| `HOST_PORT` | 3000 | Service port number |
| `MAINTAINER` | four-docs | Docker image maintainer |
| `DESCRIPTION` | four-docs | Docker image description |
| `AUTO_RELOAD` | false | Enable auto reload (development mode) |
| `DOCSIFY_NAME` | FourFour Docsify | Documentation site name |
| `DOCSIFY_VERSION` | 2.20.1 | Version number display |
| `DOCSIFY_BASE_PATH` | docs | Documentation base path (without trailing slash) |
| `DOCSIFY_ROUTER_MODE` | hash | Router mode (hash/history) |
| `DOCSIFY_SUB_MAX_LEVEL` | 5 | Sidebar maximum level |
| `DOCSIFY_SIDEBAR_DISPLAY_LEVEL` | 5 | Sidebar display level |
| `DOCSIFY_REPO` | (empty) | GitHub repository URL |
| `BAIDU_TJ_ID` | (empty) | Baidu Analytics ID |
| `VALINE_APP_ID` | (empty) | Valine comment AppId |
| `VALINE_APP_KEY` | (empty) | Valine comment AppKey |
| `AUTH_ENABLE` | true | Enable authentication |
| `AUTH_PASSWORD` | (empty) | Authentication password (MD5) |

### Configuration Examples

#### Disable Authentication

```env
AUTH_ENABLE=false
```

#### Configure Valine Comment System

```env
VALINE_APP_ID=your_app_id
VALINE_APP_KEY=your_app_key
```

#### Configure Baidu Analytics

```env
BAIDU_TJ_ID=your_baidu_tj_id
```

## Project Structure

```
fourfour-docsfiy/
├── docs/                  # Documentation content directory
│   ├── README.md         # Home page documentation
│   ├── _coverpage.md     # Cover page
│   ├── _navbar.md        # Navigation bar
│   ├── _sidebar.md       # Sidebar
│   └── README.assets/    # Documentation assets
├── static/               # Static resources
│   ├── css/             # Custom styles
│   └── icon/            # Website icons
├── index.html           # Docsify main configuration file
├── nginx.conf           # Nginx configuration file
├── docker-entrypoint.sh # Docker entrypoint script
├── Dockerfile           # Docker image build file
├── docker-compose.yml   # Docker Compose configuration
├── .env.example         # Environment variables example
├── .dockerignore        # Docker ignore file
└── publish.sh           # Publish script
```

## Common Commands

### Docker Related

```bash
# Build image
docker-compose build

# Start service
docker-compose up -d

# Restart service
docker-compose restart

# Stop service
docker-compose down

# View logs
docker-compose logs -f

# Enter container
docker-compose exec docs sh

# Check container status
docker-compose ps
```

### Documentation Updates

#### Development Mode (Recommended)

1. Edit or add Markdown files in `docs/` directory
2. Update `_sidebar.md` to add new document links
3. **If `AUTO_RELOAD` is enabled**, browser will automatically refresh to show latest content
4. **If auto reload is disabled**, manually refresh the browser (F5)

#### Production Mode

1. Modify documentation files
2. Rebuild and deploy:

```bash
docker-compose down
docker-compose up -d --build
```

## Advanced Configuration

### Custom Port

Edit `docker-compose.yml` to modify port mapping:

```yaml
ports:
  - "8080:80"  # Change 3000 to your desired port
```

### Production Deployment

#### Using Docker Hub

```bash
# Build and tag image
docker build -t yourusername/fourfour-docs:latest .

# Push to Docker Hub
docker push yourusername/fourfour-docs:latest

# Pull and run on another server
docker run -d -p 3000:80 --env-file .env yourusername/fourfour-docs:latest
```

#### Using Nginx Reverse Proxy

```nginx
server {
    listen 80;
    server_name docs.yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### HTTPS Configuration

Use Let's Encrypt free certificate:

```bash
# Install certbot
sudo apt-get install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d docs.yourdomain.com
```

## Troubleshooting

### Container Cannot Start

```bash
# View detailed logs
docker-compose logs docs

# Check configuration syntax
docker-compose config
```

### Documentation Not Displaying

1. Check if `README.md` exists in `docs/` directory
2. Verify `_sidebar.md` configuration is correct
3. Check browser console for error messages
4. Clear browser cache or force refresh (Ctrl+Shift+R)

### Auto Reload Not Working

1. Confirm `AUTO_RELOAD=true` in `.env` file
2. Restart container: `docker-compose down && docker-compose up -d`
3. Check logs: `docker-compose logs docs`
4. Ensure accessing via `localhost` or `127.0.0.1`
5. Open browser console to check for "Auto-reload enabled" log

### Page Not Updating After File Modification

1. **Check if volume mount is working**:
   ```bash
   docker exec -it fourfour-docs ls -la /usr/share/nginx/html/docs/
   ```

2. **Clear browser cache**:
   - Open developer tools (F12)
   - Network tab → Check "Disable cache"
   - Force refresh page (Ctrl+Shift+R)

3. **Check Nginx cache configuration**:
   - Confirm Markdown files are configured not to cache in `nginx.conf`

### Environment Variables Not Taking Effect

1. Ensure `.env` file is in the same directory as `docker-compose.yml`
2. Rebuild container: `docker-compose up -d --build`
3. Check if environment variables are correctly passed: `docker-compose exec docs env`

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Issues and Pull Requests are welcome!

## Contact

If you have any questions, please contact us through:

- Submit an Issue
- Send email to: 383781284@qq.com

---

**FourFour** - Making documentation management easier 🚀

![logo](./docs/_coverpage.assets/fourfour.png)
