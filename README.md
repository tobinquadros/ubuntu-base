**Note:** Pull requests and issues are welcome, see
[Contributing](#contributing).

# Ubuntu-base

## Preseeding

The [preseed.cfg](preseeds/preseed.cfg) configuration file is fully automated
and ready for use with Packer. It attempts to be quite minimal while allowing
other Packer provisioning methods to further build the system.

You can also use the [preseed.cfg](preseeds/preseed.cfg) file without Packer.
I've added a small `serve_preseed.py` script in the
[preseeds](preseeds) directory that allows you to serve the
[preseed.cfg](preseeds/preseed.cfg) file up without Packer if desired. It works
great with virtualbox as the DHCP server, but you have to manually type the installer boot parameters. Please give me comments/feedback if
you have issues on your system.

## Packer

To find available Packer build options:

```sh
packer inspect template.json
```

To run all builders:

```sh
packer build template.json
```

To run ONLY a specific builder use the -only option:

```sh
packer build -only="virtualbox-iso" template.json
```

#### Override Variables

The shell provisioner `bootstrap.sh` will install the `salt-master` and
`salt-minion` daemons by default. To run a builder that changes the default
salt-bootstrap arguments you can override the `salt-bootstrap-args` variable in
[template.json](template.json). _(see the
[salt-bootstrap.sh](https://github.com/saltstack/salt-bootstrap) source for all
options)_.

###### This option skips a salt install

```sh
packer build -var "salt-bootstrap-args=-N" template.json
```

To run a build with preset [template.json](template.json) user variables, pass
in a .json variable file _(or multiple files)_. Premade variable files are
stored in the [environments](environments) directory. For instance, to build
Ubuntu Desktop instead of the default Ubuntu Server 14.04, pass the
[environments/desktop.json](environments/desktop.json) variable file at the
command line. You can also create a new variable files and save a custom build.

```sh
packer build -var-file="environments/desktop.json" template.json
```

_(run `packer inspect template.json` to see all variables that are exposed in
[template.json](template.json))_

## Vagrant Box

For the "virtualbox-iso" builder, the default user will be `Vagrant
User`,username= `vagrant`, password= `vagrant`. This build will be immediately
ready for use. `vagrant up` will add a local vagrant box named `packer-ubuntu`,
unless there is already a `packer-ubuntu` box added. (_See Note_)

**Note:** If you've already added a box named `packer-ubuntu`, the previously
added box will be started which will not be the most recent build. To prevent
confusion, after a build is complete I run.

```bash
vagrant box remove packer-ubuntu
vagrant up
vagrant ssh  # optional, sometimes the VB GUI is needed
```

If the vagrant box works as you expected, you may want to add the new box to
Vagrant under a different name. Maybe something that will be used on multiple
systems.

```sh
vagrant box add my_ubuntu packer_virtualbox-iso_virtualbox.box
```

Use `--force` to replace a previous box:

```sh
vagrant box add --force my_ubuntu packer_virtualbox-iso_virtualbox.box
```

After a build, you will find the `packer_virtualbox-iso_virtualbox.box` build
artifact in the current working directory.

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

###### Currently builds will not preseed salt-keys

To bypass intial salt-key configuration call the highstate like a masterless node:

```sh
sudo salt-call --local state.highstate
```

###### OR: with master and minion daemons running

```sh
sudo salt-key -A  # Accepts all keys (insecure, OK for testing)
```

## USB Drive

To create a USB Drive from an Ubuntu .iso. _(Works on Mac OS X only)_

```sh
./make_usb.sh
```

Follow the prompts, you will need to have an Ubuntu iso image to use. A future
version may be capable of creating usb drives from a packer build. You can find
Ubuntu .iso downloads [here](http://www.ubuntu.com/download).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
