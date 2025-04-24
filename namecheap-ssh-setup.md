# Setting Up SSH Access on Namecheap Shared Hosting

This guide will help you set up SSH access to your Namecheap shared hosting account and deploy your Laravel application.

## 1. Enable SSH Access on Namecheap

1. Log in to your Namecheap account
2. Go to "Account Panel" > "Hosting List"
3. Find your hosting package and click "Manage"
4. In the cPanel dashboard, search for "SSH Access" or "SSH/Shell Access"
5. Click on "SSH Access" or "SSH/Shell Access"
6. Make sure SSH access is enabled (if not, enable it)
7. Click on "Manage SSH Keys"
8. Select "Import Key" or "Import SSH Key"
9. Paste your public SSH key:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKrVOIV2hrkABNtSBMpNfGPkDigEb9mlKAnu0KCr2Q2b vpavasov@gmail.com
```

10. Give the key a name (e.g., "My Laptop")
11. Click "Import" or "Save"
12. After importing, you may need to "Authorize" the key
13. Note your SSH username and hostname (usually displayed on the SSH Access page)

## 2. Test SSH Connection

Open your terminal and try connecting to your server:

```bash
ssh giewjrvx@66.29.146.222 -p21098
```

Note that Namecheap uses a non-standard SSH port (21098) for security reasons.

If successful, you should be logged into your server without being prompted for a password.

## 3. Configure Your Local Environment for Deployment

1. Create an SSH config entry for easier access:

```bash
# Add this to your ~/.ssh/config file
Host namecheap
    HostName 66.29.146.222
    User giewjrvx
    Port 21098
    IdentityFile ~/.ssh/id_ed25519
```

2. Test the connection using the alias:

```bash
ssh namecheap
```

## 4. Prepare Your Server for Laravel

Once connected to your server via SSH, set up the environment for Laravel:

1. Check PHP version:
```bash
php -v
```

2. Make sure you have the required PHP extensions:
```bash
php -m
```

3. Check if Composer is installed:
```bash
composer -V
```

4. If Composer is not installed, install it:
```bash
curl -sS https://getcomposer.org/installer | php
mv composer.phar ~/bin/composer
chmod +x ~/bin/composer
```

## 5. Set Up Database

1. In cPanel, go to "MySQL Databases"
2. Create a new database (e.g., `a2a_marketplace`)
3. Create a new database user
4. Add the user to the database with all privileges
5. Note the database name, username, and password for your Laravel `.env` file

## 6. Deploy Your Application

You can deploy your application using Git or SFTP:

### Using Git:

1. SSH into your server
2. Navigate to your web directory (usually `public_html` or a subdomain directory)
3. Clone your repository:
```bash
git clone https://github.com/vpavasovcase/a2a-marketplace.git .
```
4. Install dependencies:
```bash
composer install --no-dev --optimize-autoloader
npm install
npm run build
```
5. Set up your `.env` file:
```bash
cp .env.example .env
php artisan key:generate
```
6. Edit the `.env` file with your database credentials and other settings
7. Run migrations:
```bash
php artisan migrate
```
8. Set proper permissions:
```bash
chmod -R 755 storage bootstrap/cache
```

### Using SFTP:

You can also use SFTP to upload your files. Many code editors and IDEs have built-in SFTP support, or you can use tools like FileZilla.

## 7. Configure Web Server

Namecheap shared hosting typically uses Apache. You'll need to ensure your Laravel application is properly configured:

1. Make sure the document root points to the `public` directory of your Laravel application
2. Check if `.htaccess` file is present in the `public` directory
3. If needed, create or modify `.htaccess` to properly route requests to your Laravel application

## 8. Set Up Automatic Deployment (Optional)

For automatic deployment, you can set up a simple deployment script:

```bash
#!/bin/bash
# deployment.sh

# Pull the latest changes
git pull

# Install/update dependencies
composer install --no-dev --optimize-autoloader
npm install
npm run build

# Run migrations
php artisan migrate --force

# Clear caches
php artisan cache:clear
php artisan config:clear
php artisan view:clear

# Set proper permissions
chmod -R 755 storage bootstrap/cache
```

Then you can run this script whenever you want to deploy updates:

```bash
ssh namecheap 'cd public_html && bash deployment.sh'
```

## Troubleshooting

- **Permission Issues**: If you encounter permission issues, you may need to adjust file permissions or contact Namecheap support
- **PHP Version**: Make sure your PHP version meets Laravel's requirements (PHP 8.1+ for Laravel 10)
- **Memory Limits**: Shared hosting often has memory limits that might affect Composer or Laravel operations
- **Database Connection**: Double-check your database credentials in the `.env` file

## Additional Resources

- [Laravel Deployment Documentation](https://laravel.com/docs/10.x/deployment)
- [Namecheap cPanel Documentation](https://www.namecheap.com/support/knowledgebase/article.aspx/1974/29/how-to-access-cpanel/)
- [Namecheap SSH Access Documentation](https://www.namecheap.com/support/knowledgebase/article.aspx/9427/2218/how-to-use-ssh-to-connect-to-a-hosting-account/)
