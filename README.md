# Ubuntu-base

## Preseed

Automated preseed configurations can be found in the preseeds/ directory. These have been tested against Ubuntu 14.04.

The default user will be "Vagrant User", username= vagrant, password= vagrant.

## Bootstrap / Provision

After the automated _(or manual)_ install is complete the system has a custom Ubuntu base to bootstrap from for specific usage. The default is to setup a Vagrant Virtualbox with Salt as the provisioner. To customize this provisioning before the Packer build you have some options _(not required or exhaustive)_:

+ Place additions/changes in bootstrap.sh _(be cautious of function sequence)_. You must pass any arguments to the script as environment variables to packer!!! More on that later.
```sh
./bootstrap --help # For more info, some options are required
```

+ Upload or clone your custom Salt state-tree and pillars onto the machine after the build. This functionality could be put in bootstrap.sh, or you can perform it separately. NOTE: currently this build does not preseed salt-keys, to bypass intial salt-key configuration call the highstate like a masterless node:
```sh
sudo salt-call --local state.highstate
```

## Packer

+ To find available Packer build options. _(or just look in template.json)_
```sh
packer inspect template.json
```

+ To run the default builder. _(default is virtualbox w/ vagrant)_
```sh
packer build template.json
```

+ To run only a specific builder use the -only option _(use 'inspect' to see builder options)_
```sh
packer build -only=docker template.json
```

## Vagrant Box

+ By default no salt states will be uploaded during the packer build, the ssh configs to improve the speed of Vagrant connections will available in the salt shared folder, uncomment in the Vagrantfile to enable them.
```sh
# Uncomment to sync the salt-tree folders.
# config.vm.synced_folder "salt/state_tree/", "/srv/salt/", create: true
# config.vm.synced_folder "salt/pillar_roots/", "/srv/pillar/", create: true
```

+ You will have a very minimal state tree available on the VM at /srv/salt, /srv/pillar.
```sh
# salt/ or /srv/
├── pillar_roots
    └── top.sls
└── state_tree
    ├── ssh
    │   ├── init.sls
    │   ├── ssh_config
    │   └── sshd_config
    └── top.sls
```

+ The Vagrantfile is configured to automatically spin up the last build that was created. See config.vm.box* in the Vagrantfile to learn more.

+ To create a Vagrant box from the Packer build artifact _(aka: iso, .box)_
```sh
vagrant box add vagrant_name packer_artifact.box
```
###### Example that will replace a previous box:
```sh
vagrant box add --force my_ubuntu packer_virtualbox-iso_virtualbox.box
```
_(You can search the current working directory to verify the name of the .box artifact)_

## USB Drive

+ To create a USB Drive from an Ubuntu .iso _(Mac OS X only)_
```sh
./make_usb.sh
```
Follow the prompts, you will need to have an Ubuntu iso image to use. A future version may be capable of creating usb drives from a packer build. You can find Ubuntu .iso downloads here: http://www.ubuntu.com/download
