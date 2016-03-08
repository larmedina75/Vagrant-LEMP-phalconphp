# Vagrant-nginx-phalcon

Vagrant configuration to install Ubuntu Server LEMP + Phalcon with provision.sh file

Vagrant file to deploy a local development environment

- Ubuntu 14.04 LTS
- Ngingx
..- Default virtual host on www.phvm01.dev for test any html file or php
..- Phalcon dev virtual host on www.phalcon.dev
- Mysql
..- root password is set to "pass1234"
- PHP 
- PhalconPHP module

You can see the php modules installed at www.phvm01.dev/info.php



## Installation and deployment

Install vagrant

`$ sudo apt-get install vagrant`

Make a Vagrant Directory and one VM directory inside, like phvm01

`$ mkdir -p ~/Vagrant/phvm01`

Make Projects directory to mount development files on local file system

`$ mkdir -p ~/Projects/phalcon`

Clone this repository

`$ git clone https://github.com/larmedina75/Vagrant-LEMP-phalconphp.git`

Go to vagrant vm file and up the virtual machine

`$ vagrant up`

## Configuration of host names

Edit the /etc/hosts file and add the IP and host names to be accessible from your host system.

sudo nano /etc/hosts

Add this line to the end of the file

`10.4.4.51      www.phvm01.dev www.phalconphp.dev`

Save the file and open a web browser to access this pages and start to develop whit PhalcoPHP 

## Customization

You can adapt this configuration to create more VMs by example have phvm02, phvm0, etc. or have several projects.
Just copy the text between `# start Project` and `# end Project`, change some values like "phalconphp" by your new project name and insert modified text after # end Project.