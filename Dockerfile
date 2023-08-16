############################################################################
# PHP Extension configuration
############################################################################
# Install the following extensions.
# Note: This line must come before the FROM line.
ARG PHP_EXTENSIONS="apcu pgsql bz2 imagick igbinary gd intl imap"

# Install the cron service
# Note: This line must come before the FROM line.
ARG INSTALL_CRON=1

############################################################################
# Source image selection
############################################################################
# Build the image from thecodingmachine.
FROM thecodingmachine/php:8.1-v4-slim-apache

# If using the Apache image in production, switch the user back to www-data.
# https://github.com/thecodingmachine/docker-images-php#using-this-image-in-production
ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data

############################################################################
# PHP Configuration
############################################################################
# Set any php.ini settings here.
# Use the production php.ini file as a base.
ENV TEMPLATE_PHP_INI=production

# Configure Memory limit to something higher.
ENV PHP_INI_MEMORY_LIMIT=1g

# How many GET/POST/COOKIE input variables may be accepted
# See MDL-71390 for more info. This is the recommended / required
# value to support sites having 1000 courses, activities, users....
ENV PHP_INI_MAX_INPUT_VARS=5000

# Increase the maximum filesize to 200M, which is a more realistic figure.
ENV PHP_INI_UPLOAD_MAX_FILESIZE=200M

# Increase the maximum post size to accomodate the increased upload_max_filesize.
# The default value is 6MB more than the default upload_max_filesize.
ENV PHP_INI_POST_MAX_SIZE=206M

############################################################################
# cron configuration
############################################################################
# The cron daemon used by thecodingmachine images is supercronic.
# https://github.com/thecodingmachine/docker-images-php#supercronic-options

# By default it does not allow overlappign cron jobs, but Moodle benefits
# from these.
ENV SUPERCRONIC_OPTIONS="-overlapping"

# Configure the Moodle cron job to run regularly.
# This configuration runs every 15 seconds, but you may need to tailor to
# your requirements.
# example.
# https://github.com/thecodingmachine/docker-images-php#setting-up-cron-jobs
ENV CRON_USER=www-data \
    CRON_SCHEDULE="*/15 * * * *" \
    CRON_COMMAND="php /var/www/html/admin/cli/cron.php"

