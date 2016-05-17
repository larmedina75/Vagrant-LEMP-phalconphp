# Vagrant-nginx-phalcon

Vagrant configuration files to install Ubuntu Server with LEMP + Phalcon through provision.sh file to deploy a local development environment with:

* Ubuntu 14.04 LTS

* Ngingx

    * Default virtual host on www.phvm01.dev for test any html file or php

    * Phalcon dev virtual host on www.phalcon.dev

* Mysql

    * root password is set to "pass1234"

* PHP 

* and PhalconPHP module

You can see the php modules installed at www.phvm01.dev/info.php



## Installation and deployment

Install vagrant, remember that must be download the installer file from https://www.vagrant.com/downloads.html
This configuration requieres some software packages to work.

`$ sudo apt-get install git nfs-common nfs-kernel-server`

Make Projects directory to mount development files on local file system

`$ mkdir -p ~/Projects/phalcon`

Make a Vagrant Directory and one VM directory inside, like phvm01

`$ mkdir -p ~/Vagrant`

Clone this repository

`$ git clone https://github.com/larmedina75/Vagrant-LEMP-phalconphp.git phvm01`

Go to Vagrant vm directory and download the the virtual machine

`$ cd ~/Vagrant/phvm01`
`$ vagrant box add ubuntu/trusty64`

And start the vagrant box

`$ vagrant up`

## Configuration of host names

Edit the /etc/hosts file and add the IP and host names to be accessible from your host system.

`sudo nano /etc/hosts`

Add this line to the end of the file

`10.4.4.51      www.phvm01.dev www.phalconphp.dev`

Save the file and open a web browser to access this pages and start to develop whit PhalcoPHP 

## Customization

You can adapt this configuration to create more VMs by example have phvm02, phvm03, etc.

Edit the provision.sh script fil and just copy the text between `# start Project` and `# end Project`, change some values like "phalconphp" by your new project name and insert modified text after `# end Project`.

You may need to add some lines to the `/etc/hosts` file and include the mount command to Vagrantfile whit the new path.