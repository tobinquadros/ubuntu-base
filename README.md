**Note:** Pull requests and issues are welcome, see
[Contributing](#contributing).

# Ubuntu-base

Containers are cool, but sometimes you just need a full VM to investigate or
develop at the system and kernel level. I use this setup to assemble Ubuntu
systems that I can break, change, and learn from.

This repo enables building of custom Ubuntu images for Virtualbox and Vagrant.
It will build and deploy artifacts directly to Hashicorp's Atlas service for
public/private access once you've created your own `atlas.json` var-file.

## Configuration For Hashicorp's Atlas

_Note:You need an Atlas account to push artifacts to Atlas!_

Hashicorp's Atlas service will require the `atlas_token` and `atlas_username`
variables to be set. Place a file at `var-files/atlas.json` (it's .gitignored)
with the following key/value pairs.

```json
{
  "atlas_username": "username",
  "atlas_token": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
```

The [template.json](template.json) file will accept those variables and push
vagrant boxes to the specified Atlas account. 

## To Preseed Ubuntu

Preseeding provides a way to set answers to questions asked during the
installation process without having to manually enter answers while the
installation is running. This makes it possible to fully automate most
installations and offers some features not available during normal
installation. For more info see
https://help.ubuntu.com/lts/installation-guide/armhf/apb.html

The [preseed.cfg](preseeds/preseed.cfg) file is capabale of full automation and
ready for use with Packer. It attempts to be minimal while allowing other
provisioning methods to further build the system if desired. 

## To Kick Off A Build With Packer

Use the [Makefile](Makefile)

```sh
make build
```

### To See All Packer Build Options

You can override the Ubuntu version and a few other attributes through the
[template.json](template.json) file.

```sh
packer inspect template.json
```

## Vagrant & Virtualbox Artifacts

After a build, you will have two build artifacts:

- Local vagrant box at `./vagrant-boxes/ubuntu-base-virtualbox.box` (.gitignored)
- Remote vagrant box at atlas.hashicorp.com/username/ubuntu-base with new version

The default user will be username=`vagrant`, password=`vagrant`. 

### To Use The Local Vagrant Box

This is useful for testing a build artifact through the
[Vagrantfile](Vagrantfile) without having to wait for download from Atlas.

```sh
make pull-local
```

### To Use The Atlas (remote) Vagrant Box

Get the latest version of the official vagrant box stored on Atlas

```sh
make pull-remote
```

Or, in a new project run

```sh
vagrant init atlas_username/ubuntu-base
```

## USB Drive

**Note**: OS X only. You will need to have an Ubuntu iso image to use. You can
find Ubuntu images and hashes [here](http://releases.ubuntu.com).


To create a USB Drive from an Ubuntu .iso:

```sh
./make_usb.sh  # then follow prompts
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
