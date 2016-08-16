**Note:** Pull requests and issues are welcome, see
[Contributing](#contributing).

# Ubuntu-base

Builds custom Ubuntu images for Docker, Virtualbox (vagrant), and AWS. I mostly
use this setup to assemble Ubuntu systems that I can break, change, and learn
from.

## Preseeding

The [preseed.cfg](preseeds/preseed.cfg) file is fully automated and ready for
use with Packer. It attempts to be quite minimal while allowing other Packer
provisioning methods to further build the system if desired.

## Packer

To find available Packer build options:

```sh
packer inspect template.json
```

To run all builders (docker, virtualbox, & aws):

```sh
packer build -var-file="var-files/ubuntu.json" template.json
```

To run ONLY a specific builder (use the -only flag):

```sh
packer build -only="virtualbox-iso" -var-file="var-files/ubuntu.json" template.json
```

## Vagrant & Virtualbox

After a virtualbox build, you will find a build artifact located at
`vagrant-boxes/custom-virtualbox.box`.

The default user will be username=`vagrant`, password=`vagrant`. Running
`vagrant up` will add a local Vagrant box named `custom`. If you've already
added the `custom` box, the previous box will be started instead. To remove the
old and update to the new custom build run:

```bash
vagrant destroy -f
vagrant box remove tobinquadros/custom
vagrant up
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
