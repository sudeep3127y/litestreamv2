#!/bin/bash

# Minify HTML
html-minifier --collapse-whitespace test.html -o test_min.html

# Minify CSS
cssnano css/bootstrap.css dist/css/bootstrap.css

# Minify JS
uglifyjs js/script.js -o js/script_min.js

# 1. Minify your HTML, CSS, and JavaScript files
html-minifier --input-dir . --output-dir . --collapse-whitespace --remove-comments
cleancss -o style.min.css style.css
uglifyjs script.js -o script.min.js

# 2. Enable compression
echo "AddOutputFilterByType DEFLATE text/plain text/html text/xml text/css application/x-javascript application/javascript" | sudo tee /etc/apache2/mods-available/deflate.conf
sudo a2enmod deflate
sudo service apache2 restart

# 3. Enable browser caching
echo "ExpiresActive On
ExpiresByType text/css 'access plus 1 year'
ExpiresByType application/javascript 'access plus 1 year'
ExpiresByType application/x-javascript 'access plus 1 year'
ExpiresByType image/x-icon 'access plus 1 year'
ExpiresByType image/jpg 'access plus 1 year'
ExpiresByType image/jpeg 'access plus 1 year'
ExpiresByType image/gif 'access plus 1 year'
ExpiresByType image/png 'access plus 1 year'" | sudo tee /etc/apache2/mods-available/expires.conf
sudo a2enmod expires
sudo service apache2 restart

# 4. Optimize images
find . -type f -iname "*.jpg" -or -iname "*.jpeg" -or -iname "*.png" -or -iname "*.gif" | while read img; do
  mogrify -strip -interlace Plane -quality 80 "$img"
done

# 5. Enable KeepAlive
echo "KeepAlive On
KeepAliveTimeout 5" | sudo tee /etc/apache2/mods-available/keepalive.conf
sudo a2enmod headers
sudo service apache2 restart

# 6. Remove unused CSS and JavaScript
uncss -m -u -r -C .csscomb.json --url file://$PWD/index.html > style.clean.css
uglifyjs -m -c -o script.clean.js script.min.js


#!//bash
# Define the list pages to preloadpages=("https://litestream.pages.dev//"
       "https://litestream.pages.dev/about"
       "https://litestream.pages.dev/contact")

# Loop through the list of pages and make requests to them
for page in "${pages[@]}"; do
  curl -s "$page" > /dev/null
done

echo "Cache warmed up!"