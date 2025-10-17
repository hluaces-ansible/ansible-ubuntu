dependencies:
	pip3 install -r requirements.txt
	ansible-galaxy role install -r roles/requirements.yml -p roles/vendors
	ansible-galaxy collection install -r collections/requirements.yml -p collections/vendors

	# Required for https://github.com/ansible-community/molecule-plugins/issues/301
	# See https://github.com/ansible-community/molecule-plugins/issues/301#issuecomment-3184082904
	ln -fs $(shell python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')/molecule_plugins/vagrant plugins/modules/

clean:
	rm -rf roles/vendors/* collections/vendors/*
	molecule cleanup --all
	molecule destroy --all
	rm -rf plugins/modules/vagrant

test:
	molecule test $(TEST_ARGS)

provision:
	./provision.sh

provision-check:
	./provision.sh --check
