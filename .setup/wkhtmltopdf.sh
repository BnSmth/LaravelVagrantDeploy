#!/usr/bin/env bash

# Install wkhtmltopdf and all dependencies.
sudo aptitude -y install openssl build-essential xorg libssl-dev
wget http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.10.0_rc2-static-i386.tar.bz2
tar xvjf wkhtmltopdf-0.10.0_rc2-static-i386.tar.bz2
sudo mv wkhtmltopdf-i386 /usr/local/bin/wkhtmltopdf
chmod +x /usr/local/bin/wkhtmltopdf
