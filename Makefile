dependencies:
	pip3 install -r requirements.txt
	ansible-galaxy role install -r roles/requirements.yml -p roles/vendors
	ansible-galaxy collection install -r collections/requirements.yml -p collections/vendors

clean:
	rm -rf roles/vendors/* collections/vendors/*
	molecule destroy --all

test:
	ANSIBLE_CONFIG=$(CURDIR)/ansible.cfg molecule test $(TEST_ARGS)

provision:
	./provision.sh

provision-check:
	./provision.sh --check
