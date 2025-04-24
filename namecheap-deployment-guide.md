# A2A Marketplace Deployment Guide for Namecheap

This guide will help you deploy the A2A Marketplace application to your Namecheap shared hosting account using GitHub Actions for CI/CD.

## Prerequisites

- Namecheap shared hosting account
- SSH access to your hosting account
- MySQL database created in cPanel
- Domain configured to point to your hosting account
- GitHub repository for your project

## Step 1: Set Up Database in cPanel

1. Log in to your Namecheap cPanel
2. Go to "MySQL Databases"
3. Create a new database (e.g., `your_database_name`)
4. Create a new database user with a username and password
5. Add the user to the database with all privileges
6. Note the database name, username, and password

**Important**: On Namecheap shared hosting, database usernames are typically in the format `cpanel_username_database_user` (e.g., `your_database_username`). Make sure to use the full username when configuring your Laravel application.

## Step 2: Configure DNS Settings

1. Log in to your Namecheap account
2. Go to the Domain List and select `a2a-marketplace.com`
3. Click "Manage" and then "Advanced DNS"
4. Make sure the domain points to your hosting server
5. Wait for DNS propagation (can take up to 24-48 hours)

## Step 3: Set Up CI/CD with GitHub Actions

1. Generate an SSH key pair for GitHub Actions:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "github-actions-deploy" -f ~/.ssh/github_actions
   ```

2. Add the public key to your server's authorized_keys file:
   ```bash
   cat ~/.ssh/github_actions.pub >> ~/.ssh/authorized_keys
   ```

3. Add the required secrets to GitHub:
   - Go to your GitHub repository
   - Navigate to Settings > Secrets and variables > Actions
   - Click "New repository secret" and add the following secrets:
     - Name: `SSH_PRIVATE_KEY`, Value: (paste the content of ~/.ssh/github_actions)
     - Name: `DB_NAME`, Value: your database name (e.g., `your_database_name`)
     - Name: `DB_USER`, Value: your database username (e.g., `your_database_username`)
     - Name: `DB_PASSWORD`, Value: your database password

4. Upload the server-side deployment script to your server:
   ```bash
   scp -P 21098 server-deploy.sh giewjrvx@66.29.146.222:~/
   chmod +x ~/server-deploy.sh
   ```

## Step 4: Deploy the Application

### Option 1: Using GitHub Actions (Recommended)

1. Push your code to the main branch of your GitHub repository:
   ```bash
   git push origin main
   ```

2. GitHub Actions will automatically deploy your application to Namecheap

3. You can also manually trigger a deployment from the GitHub Actions tab

### Option 2: Using the Server-Side Deployment Script

1. SSH into your server:
   ```bash
   ssh giewjrvx@66.29.146.222 -p21098
   ```

2. Create a file to store your database credentials (do this only once):
   ```bash
   echo 'export DB_NAME="your_database_name"' > ~/.deploy-env
   echo 'export DB_USER="your_database_username"' >> ~/.deploy-env
   echo 'export DB_PASSWORD="your_database_password"' >> ~/.deploy-env
   chmod 600 ~/.deploy-env
   ```

3. Run the deployment script with the environment variables:
   ```bash
   source ~/.deploy-env && bash ~/server-deploy.sh
   ```

### Option 3: Using the Local Deployment Script

1. Update the database credentials in the deployment script:
   ```bash
   # Open the deploy.sh file
   nano deploy.sh

   # Update the database configuration section
   DB_NAME="your_database_name"
   DB_USER="your_database_username"
   DB_PASSWORD="your_database_password"
   ```

2. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

### Option 3: Manual Deployment

1. Build the application locally:
   ```bash
   npm run build
   ```

2. Create a deployment package:
   ```bash
   zip -r deploy.zip . -x "node_modules/*" "vendor/*" ".git/*" "storage/logs/*" "storage/framework/cache/*" "storage/framework/sessions/*" "storage/framework/views/*"
   ```

3. Upload the deployment package to your server:
   ```bash
   scp -P 21098 deploy.zip giewjrvx@66.29.146.222:public_html/
   ```

4. SSH into your server:
   ```bash
   ssh giewjrvx@66.29.146.222 -p21098
   ```

5. Extract the deployment package:
   ```bash
   cd public_html
   unzip -o deploy.zip
   ```

6. Set up the environment file:
   ```bash
   cp .env.namecheap .env
   # Edit the .env file with your database credentials
   nano .env
   ```

7. Install dependencies:
   ```bash
   composer install --no-dev --optimize-autoloader
   ```

8. Run migrations:
   ```bash
   php artisan migrate --force
   ```

9. Set proper permissions:
   ```bash
   chmod -R 755 storage bootstrap/cache
   ```

## Step 5: Verify the Deployment

1. Visit your domain in a web browser:
   ```
   https://a2a-marketplace.com
   ```

2. Check for any errors in the Laravel log:
   ```bash
   ssh giewjrvx@66.29.146.222 -p21098 "tail -n 100 public_html/storage/logs/laravel.log"
   ```

## Troubleshooting

### Apache Configuration Issues

If you encounter issues with Apache configuration:

1. Check if mod_rewrite is enabled:
   - Visit `https://a2a-marketplace.com/phpinfo.php`
   - Look for 'mod_rewrite' in the Apache modules section

2. Verify that .htaccess files are working:
   - Create a test file with invalid syntax
   - If Apache returns a 500 error, .htaccess files are being processed

3. Make sure AllowOverride is set to All:
   - This is typically already configured on Namecheap shared hosting
   - If not, contact Namecheap support to enable it

4. Check the Apache error logs in cPanel for any specific errors

### Database Connection Issues

If you encounter database connection issues:

1. Verify your database credentials in cPanel
   - Go to MySQL Databases in cPanel
   - Check the list of databases and users
   - Make sure the user has been added to the database with the correct permissions

2. Test the database connection using a simple PHP script:
   ```php
   <?php
   // Database connection test script
   $host = 'localhost';
   $dbname = 'your_database_name';
   $username = 'your_database_username';
   $password = 'your_database_password';

   try {
       $conn = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
       $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
       echo "Connected successfully to the database!";
   } catch(PDOException $e) {
       echo "Connection failed: " . $e->getMessage();
   }
   ?>
   ```

3. Check if the database server allows connections from your hosting account

4. Update the `.env` file with the correct credentials

5. If you're still having issues, contact Namecheap support for assistance with database access

### MySQL Key Length Issues

If you encounter errors like "Specified key was too long; max key length is 1000 bytes" during migrations:

1. This is a common issue with MySQL < 5.7.7 or MariaDB < 10.2.2

2. The solution is to set a default string length in the AppServiceProvider:
   ```php
   // In app/Providers/AppServiceProvider.php
   use Illuminate\Support\Facades\Schema;

   public function boot()
   {
       Schema::defaultStringLength(191);
       // Other boot code...
   }
   ```

3. After making this change, clear the Laravel cache:
   ```bash
   php artisan cache:clear
   php artisan config:clear
   ```

4. Run the migrations again:
   ```bash
   php artisan migrate --force
   ```

### Cache Table Issues

If you encounter errors related to missing cache tables:

1. Create the cache table using the Laravel command:
   ```bash
   php artisan cache:table
   php artisan migrate
   ```

2. Ensure the cache directories exist and have proper permissions:
   ```bash
   mkdir -p storage/framework/cache
   mkdir -p storage/framework/sessions
   mkdir -p storage/framework/views
   chmod -R 775 storage/framework
   ```

### Tables Already Exist Issues

If you encounter errors like "Table 'users' already exists" during migrations:

1. This usually happens when you're trying to run migrations on a database that already has tables

2. You can use the `--force` option to continue with other migrations:
   ```bash
   php artisan migrate --force
   ```

3. If you want to start fresh, you can reset the database (WARNING: this will delete all data):
   ```bash
   php artisan migrate:fresh --force
   ```

4. If you want to keep the existing tables but add missing ones, just continue with the deployment

### File Permission Issues

If you encounter file permission issues:

1. Set the correct permissions for the storage and bootstrap/cache directories:
   ```bash
   chmod -R 755 storage bootstrap/cache
   ```

2. Make sure the web server user has write access to these directories:
   ```bash
   chown -R giewjrvx:nobody storage bootstrap/cache
   ```

### GitHub Actions Deployment Issues

If you encounter issues with GitHub Actions deployment:

1. Check the GitHub Actions logs in your repository's Actions tab

2. Verify that the SSH_PRIVATE_KEY secret is correctly set up

3. Make sure the server-side deployment script is executable:
   ```bash
   ssh giewjrvx@66.29.146.222 -p21098 "chmod +x ~/server-deploy.sh"
   ```

4. Test the server-side deployment script manually:
   ```bash
   ssh giewjrvx@66.29.146.222 -p21098 "bash ~/server-deploy.sh"
   ```

### Domain Not Pointing to Your Hosting

If your domain is still showing the Namecheap parking page:

1. Check your DNS settings in Namecheap
2. Make sure the domain is pointing to your hosting server
3. Wait for DNS propagation (can take up to 24-48 hours)

## Additional Resources

- [Laravel Deployment Documentation](https://laravel.com/docs/10.x/deployment)
- [Namecheap cPanel Documentation](https://www.namecheap.com/support/knowledgebase/article.aspx/1974/29/how-to-access-cpanel/)
- [Namecheap MySQL Database Documentation](https://www.namecheap.com/support/knowledgebase/article.aspx/9363/2180/how-to-create-and-manage-mysql-databases-in-cpanel/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Actions for SSH Deployment](https://github.com/marketplace/actions/webfactory-ssh-agent)
