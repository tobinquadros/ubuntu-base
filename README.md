**Note:** Pull requests and issues are welcome, see
[Contributing](#contributing).

# Ubuntu-base

## Preseeding

The [preseed.cfg](preseeds/preseed.cfg) configuration file is fully automated
and ready for use with Packer. It attempts to be as minimal as possible while
allowing other Packer provisioning methods to further build the system.

## Packer

To find available Packer build options. _(or you can just view the
[template.json](template.json) file itself)_

```sh
packer inspect template.json
```

To run all builders. _(default installs Salt on all builders, and preps Vagrant
for Virtualbox)_

```sh
packer build template.json
```

To run a builder that changes the default salt-bootstrap arguments you can
overwrite the `salt-bootstrap-args` variable. If no `salt-bootstrap-args`
variable is passed the default WILL install a salt-master and salt-minion and
uses the debug flag `-D -M` _(see the
[salt-bootstrap.sh](https://github.com/saltstack/salt-bootstrap) source for all
options)_.

###### This option skips a salt install completely

```sh
packer build -var "salt-bootstrap-args=-N" template.json
```

To run ONLY a specific builder use the -only option _(run `packer inspect
template.json` to see which builders are available in
[template.json](template.json))_

```sh
packer build -only="virtualbox-iso" template.json
```

To run a build with preset Packer user variables, pass in a .json variable file
_(or multiple)_. Premade variable files are stored in the
[environments](environments) directory. For instance, to build Ubuntu Desktop
instead of the default Ubuntu Server 14.04, pass the
[environments/desktop.json](environments/desktop.json) variable file at the
command line. You can also create a new variable files and save a custom build.
_(run `packer inspect template.json` to see all variables that are exposed in
[template.json](template.json))_

```sh
packer build -var-file="environments/desktop.json" template.json
```

## Vagrant Box

For the "virtualbox-iso" builder, the default user will be `Vagrant User`,username= `vagrant`, password= `vagrant`. This build will be immediately ready for use. `vagrant up` will add a local vagrant box named `packer-ubuntu`, unless there is already a `packer-ubuntu` box added. (_See Note_)

**Note:** If you've already added a box named `packer-ubuntu`, the previously added box will be started which will not be the most recent build. To prevent confusion, after a build is complete I run.
```bash
vagrant box remove packer-ubuntu
vagrant up
vagrant ssh  # optional, sometimes the VB GUI is better
```

If the vagrant box works as you expected, you may want to add the new box to Vagrant under a different name. Maybe something that will be used on multiple systems.

```sh
vagrant box add my_ubuntu packer_virtualbox-iso_virtualbox.box
```

Use `--force` to replace a previous box:

```sh
vagrant box add --force my_ubuntu packer_virtualbox-iso_virtualbox.box
```

_(After a build, you will find the "packer_virtualbox-iso_virtualbox.box" build
artifact in the current working directory)_

## Provisioning

When the installer is finished the base system is ready to provision for more
specific usage. To customize this provisioning you have some options _(this not
required or exhaustive)_:

Place additions in [bootstrap.sh](bootstrap.sh) to be run during the Packer
build _(not a good idea, this file may be updated and is quirky)_. Also, it
seems you must pass arguments to shell scripts as environment variables when
using Packer!!! _(More on that later, believe me, just use another method)_.

###### Even without Packer, you can prep any Ubuntu box for Vagrant and Salt

```sh
./bootstrap.sh --help # For more info, some options are required
```

By default, salt-states are currently NOT uploaded during the Packer build
_(this will change once a flexible method is established)_. You can still make
salt-states immediately available for testing in Virtualbox with the
[Vagrantfile's](Vagrantfile) `config.vm.synced_folders` method. Uncomment this
line in the [Vagrantfile](Vagrantfile) to sync your host machine's entire
salt-tree to the VM _(directories may vary)_.

```sh
# Uncomment to share the host machine's salt-tree (read-only).
config.vm.synced_folder "/srv/", "/srv/", create: true, :mount_options => ["ro"]
```

+ Upload, clone, or configure the master's "gitfs\_remotes" option _(a future
  release will improve on this)_.

###### NOTE: currently this build does not preseed salt-keys, to bypass intial salt-key configuration call the highstate like a masterless node:

```sh
sudo salt-call --local state.highstate
```

###### OR: with master and minion daemons running

```sh
sudo salt-key -A  # Accepts all keys (insecure, OK for testing)
```

## USB Drive

To create a USB Drive from an Ubuntu .iso _(Mac OS X only)_

```sh
./make_usb.sh
```

Follow the prompts, you will need to have an Ubuntu iso image to use. A future
version may be capable of creating usb drives from a packer build. You can find
Ubuntu .iso downloads here: http://www.ubuntu.com/download

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
