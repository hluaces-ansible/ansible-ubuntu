ANSIBLE_ARGS=
VAGRANT_BOX="ubuntu20-desktop"

dependencies:
	ansible-galaxy role install -r roles/requirements.yml -p roles/vendors
	ansible-galaxy collection install -r collections/requirements.yml -p collections/vendors

clean:
	rm -rf roles/vendors/* collections/vendors/*

test:
	(cd vagrant; ANSIBLE_ARGS="$(ANSIBLE_ARGS)" vagrant up $(VAGRANT_BOX) --provision)

destroy:
	(cd vagrant; vagrant destroy -f)
