#!/bin/bash

echo -n "--- What is the name of this app? ---"
read appname
composer create-project laravel/laravel $appname --prefer-dist
cd $appname

# Install and Configure Way/Generators Package
echo -n "--- Add Generators and PHPUnit to $appname? : [y|n] ---"
read -e generators
if [[ $generators == "y" ]]
    then
        gsed -i '8 a\ "require-dev" : { "way/generators": "dev-master", "phpunit/phpunit": "3.7.28" },' composer.json
        composer update
        mkdir -f app/config/development
        mv app.php app/config/development
else
  rm app.php
fi

# Update app/bootstrap/start.php with env function
echo -n "--- Setting up development environment. ---"
gsed -i -e'27,31d' bootstrap/start.php
gsed -i "27a\ \$env = \$app->detectEnvironment(function() { return getenv('ENV') ?: 'development'; });" bootstrap/start.php

# Create a git repo
echo -n "--- Creating a git repository. ---"
git init
git add .
git commit -m "Initial commit"

echo -n "--- Would you like to add this repo to Github? [y|n] ---"
read -e github
if [[ $github == 'y' ]]
    then
        echo -n "--- What is your github username? ---"
        read githubUsername
        curl -u "$githubUsername" https://api.github.com/user/repos -d "{\"name\":\"$appname\"}"

        git remote add origin git@github.com:$githubUsername/$appname.git
        git push origin master
fi

echo -n "--- Would you like to setup a vagrant virtual machine? [y|n] ---"
read -e vagrant
if [[ $vagrant == 'y' ]]
    then
    
       wget https://raw.github.com/BenBradley/LaravelVagrantDeploy/master/Vagrantfile
       wget https://raw.github.com/BenBradley/LaravelVagrantDeploy/master/install.sh
       wget https://raw.github.com/BenBradley/LaravelVagrantDeploy/master/.bash_profile
       wget https://raw.github.com/BenBradley/LaravelVagrantDeploy/master/.bash_aliases
       wget https://raw.github.com/BenBradley/LaravelVagrantDeploy/master/.bash_env
       wget https://raw.github.com/BenBradley/LaravelVagrantDeploy/master/000-default.conf

       echo -n "--- Port number: (default 8080) ---"
       read -e vagrantport
       gsed -i "s/PORTNUMBER/$vagrantport/g" Vagrantfile

       echo -n "--- Database name: ---"
       read -e databasename

       echo -n "--- Database password: ---"
       read -e databasepassword

      # Replace the default password and username with the users input within install.sh, .bash-env and 000-default.conf
       gsed -i "s/DATABASENAME/$databasename/g" install.sh
       gsed -i "s/DATABASEPASSWORD/$databasepassword/g" install.sh

       gsed -i "s/DATABASENAME/$databasename/g" .bash_env
       gsed -i "s/DATABASEPASSWORD/$databasepassword/g" .bash_env

       gsed -i "s/DATABASENAME/$databasename/g" 000-default.conf
       gsed -i "s/DATABASEPASSWORD/$databasepassword/g" 000-default.conf

       echo -n "--- Creating the virtual machine. ---"       
       vagrant up
fi

# Update .gitignore
Vagrantfile >> .gitignore
.vagrant >> .gitignore
install.sh >> .gitignore

echo -n "--- Fin. ---"