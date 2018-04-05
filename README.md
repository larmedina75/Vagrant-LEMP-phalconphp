# Vagrant-nginx-phalcon

Vagrant configuration files to install Ubuntu Server with LEMP + Phalcon through provision.sh file.
This configuration deploys a local development environment with:

* Ubuntu 16.04 LTS

* Ngingx

    * Default virtual host on vm01.dev for test any html file or php

    * Phalcon dev virtual host on phalcon.dev

* Mysql

    * root password is set to "pass1234"

* PHP 

* and PhalconPHP module

You can see the php modules installed at vm01.devel/info.php



## Installation and deployment

Install vagrant, remember that must be download the installer file from https://www.vagrant.com/downloads.html
This configuration requieres some software packages to work.

`$ sudo apt-get install git nfs-common nfs-kernel-server`

Make Projects directory to mount development files on local file system

`$ mkdir -p ~/Projects/phalcon_project`

Download the Vagrantfile and provision.sh files

```
wget https://github.com/larmedina75/Vagrant-LEMP-phalconphp/raw/master/Vagrantfile
wget https://github.com/larmedina75/Vagrant-LEMP-phalconphp/raw/master/provision.sh
```

Clone your phalcon project repository and save it on  a folder with the name "phalcon"

`$ git clone [URL of your phalcon project] phalcon`

Download the the virtual machine image

```
$ vagrant box add ubuntu/xenial64
```

And start the vagrant box

`$ vagrant up`

## Configuration of host names

Edit the /etc/hosts file and add the IP and host names to be accessible from your host system.

`sudo nano /etc/hosts`

Add this line to the end of the file

`10.4.4.51      vm01.devel phalcon.devel`

Save the file and open a web browser to access this pages and start to develop whit PhalcoPHP

## Debug errors and view logs

You can view nginx logs throught a web browser, user the URL http://vm01.devel/view-logs.php and select the log file you need.

This code is work of Alexandre Plennevaux [@pixeline](https://gist.github.com/pixeline) and could be consulted [here](https://gist.github.com/pixeline/e437fae2848aa4691fbe)


![view error log file example](https://github.com/larmedina75/Vagrant-LEMP-phalconphp/imgs/viewlogs.jpg "View Nginx error log file")

## Customization

You can adapt this configuration to create more VMs by example have vm02, m03, etc.

Edit the provision.sh script file and just copy the text between `# start Project` and `# end Project`, change some values like "phalcon" by your new project name and insert modified text after `# end Project`.

You may need to add some lines to the `/etc/hosts` file and include a new path to the mount command in the Vagrantfile.
