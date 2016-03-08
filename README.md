# Vagrant-nginx-phalcon

Vagrant configuration to install Ubuntu Server LEMP + Phalcon with provision.sh file

Vagrant file to deploy a local development environment

- Ubuntu 14.04 LTS
- Ngingx
-- Default vistual host on www.phvm01.dev for test any html file or php
-- Phalcon dev virtualhost on www.phalcon.dev
- Mysql
-- root password set to "pass1234"
- PHP 
- PhalconPHP module installed

You can see list of modules at www.phvm01.dev/info.php

# Intallation and deployment

Install vagrant

`$ sudo apt-get install vagrant`

Make a Vagrant Directory and one VM directory inside, like phvm01

`$ cd ~`
`$ mkdir -p Vagrant/phvm01`

Make Proyects directory to mount develoment files on local file system

`$ cd ~`
`$ mkdir -p Proyects/phalcon`

Clone this repository

`$ git clone https://github.com/larmedina75/Vagrant-LEMP-phalconphp.git`

Go to vagrant vm file and up the virtual machine

`$ vagrant up`