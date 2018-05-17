.PHONY: playbook debug build clean pull-local pull-remote

playbook:
	ansible-playbook --ask-become-pass -v playbook.yml

debug:
	ansible-playbook --ask-become-pass -vv --tags=debug playbook.yml

pull-local: clean
	@LOCAL_URL="true" vagrant up ubuntu

pull-remote: clean
	@LOCAL_URL="" vagrant up ubuntu

clean:
	@vagrant destroy --force ubuntu
	@vagrant box remove --force --all tobinquadros/ubuntu-base || echo "box tobinquadros/ubuntu not found"

build:
	@ test -f var-files/vagrant-cloud.json || (echo "You must have a vagrant-cloud.json var-file, see README.md" && exit 1)
	packer build -var-file="var-files/vagrant-cloud.json" template.json
