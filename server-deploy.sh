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

# Clear caches safely
echo -e "${YELLOW}Clearing caches...${NC}"
php artisan config:clear
php artisan view:clear
php artisan route:clear

# Try to clear cache but ignore errors
php artisan cache:clear || echo -e "${YELLOW}Cache clear failed, but continuing...${NC}"

# Set proper permissions
echo -e "${YELLOW}Setting proper permissions...${NC}"
chmod -R 755 storage bootstrap/cache
find storage -type d -exec chmod 775 {} \;
find bootstrap/cache -type d -exec chmod 775 {} \;

# Ensure cache directories exist
echo -e "${YELLOW}Creating cache directories...${NC}"
mkdir -p storage/framework/cache
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views
chmod -R 775 storage/framework

# Create .htaccess file for Apache
echo -e "${YELLOW}Creating .htaccess file...${NC}"
cat > "$APP_DIR/public/.htaccess" << 'EOL'
<IfModule mod_rewrite.c>
    <IfModule mod_negotiation.c>
        Options -MultiViews -Indexes
    </IfModule>

    RewriteEngine On

    # Handle Authorization Header
    RewriteCond %{HTTP:Authorization} .
    RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

    # Redirect Trailing Slashes If Not A Folder...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} (.+)/$
    RewriteRule ^ %1 [L,R=301]

    # Send Requests To Front Controller...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [L]
</IfModule>
EOL

# Create a symbolic link from public_html/laravel to public_html/public
echo -e "${YELLOW}Setting up Laravel public directory...${NC}"
if [ ! -L "$APP_DIR/laravel" ]; then
    ln -sf "$APP_DIR/public" "$APP_DIR/laravel"
fi

# Create root .htaccess to redirect to public directory
echo -e "${YELLOW}Creating root .htaccess file...${NC}"
cat > "$APP_DIR/.htaccess" << 'EOL'
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteRule ^(.*)$ public/$1 [L]
</IfModule>
EOL

# Create a PHP info file to check if mod_rewrite is enabled
echo -e "${YELLOW}Creating phpinfo file to check Apache modules...${NC}"
cat > "$APP_DIR/public/phpinfo.php" << 'EOL'
<?php
phpinfo();
EOL

echo -e "${YELLOW}You can check if mod_rewrite is enabled by visiting https://a2a-marketplace.com/phpinfo.php${NC}"
echo -e "${YELLOW}Look for 'mod_rewrite' in the Apache modules section${NC}"

# Build frontend assets (if needed)
if [ -f "package.json" ]; then
    echo -e "${YELLOW}Building frontend assets...${NC}"
    npm install
    npm run build
fi

echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${YELLOW}You can now access your application at https://a2a-marketplace.com${NC}"
