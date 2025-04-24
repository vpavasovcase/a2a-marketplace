#!/bin/bash
# Server-side deployment script for A2A Marketplace
# This script pulls the latest code from GitHub and deploys it

# Set locale to Croatian to avoid locale warnings
export LANG=hr_HR.utf8
export LANGUAGE=hr_HR.utf8
export LC_ALL=hr_HR.utf8
export LC_CTYPE=hr_HR.utf8

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/vpavasovcase/a2a-marketplace.git"
APP_DIR="$HOME/public_html"
BRANCH="main"

# Check if the repository already exists
if [ -d "$APP_DIR/.git" ]; then
    echo -e "${YELLOW}Repository already exists. Pulling latest changes...${NC}"
    cd "$APP_DIR"
    git fetch origin
    git reset --hard origin/$BRANCH
else
    echo -e "${YELLOW}Cloning repository...${NC}"
    # If the directory is not empty, move existing files to a backup
    if [ "$(ls -A $APP_DIR)" ]; then
        BACKUP_DIR="$HOME/backups/public_html-$(date +%Y%m%d%H%M%S)"
        echo -e "${YELLOW}Moving existing files to $BACKUP_DIR...${NC}"
        mkdir -p "$BACKUP_DIR"
        mv "$APP_DIR"/* "$BACKUP_DIR"/ 2>/dev/null
        mv "$APP_DIR"/.[!.]* "$BACKUP_DIR"/ 2>/dev/null || true
    fi

    # Clone the repository
    git clone --branch $BRANCH $REPO_URL "$APP_DIR"
fi

# Navigate to the application directory
cd "$APP_DIR"

# Install Composer dependencies
echo -e "${YELLOW}Installing Composer dependencies...${NC}"
composer install --no-dev --optimize-autoloader

# Set proper permissions
echo -e "${YELLOW}Setting proper permissions...${NC}"
chmod -R 755 storage bootstrap/cache
find storage -type d -exec chmod 775 {} \;
find bootstrap/cache -type d -exec chmod 775 {} \;

# Build frontend assets (if needed)
if [ -f "package.json" ]; then
    echo -e "${YELLOW}Building frontend assets...${NC}"
    npm install
    npm run build
fi

php artisan migrate

php artisan optimize

echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${YELLOW}You can now access your application at https://a2a-marketplace.com${NC}"
