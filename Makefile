ANSIBLE_ARGS=
SCENARIO=default
VAGRANT_BOX="ubuntu24-desktop"
# Required for https://github.com/ansible-community/molecule-plugins/issues/301
# See https://github.com/ansible-community/molecule-plugins/issues/301#issuecomment-3184082904
MOLECULE_VAGRANT_PLUGIN_DIR := $(shell python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')/molecule_plugins/vagrant

dependencies:
	pip3 install -r requirements.txt
	ansible-galaxy role install -r roles/requirements.yml -p roles/vendors
	ansible-galaxy collection install -r collections/requirements.yml -p collections/vendors
	@echo ""
	@echo "========================================="
	@echo "Dependencies installed successfully!"
	@echo ""
	@echo "To run molecule tests manually, you need to export:"
	@echo "  export _MOLECULE_VAGRANT_PLUGIN_DIR=\"$(MOLECULE_VAGRANT_PLUGIN_DIR)\""
	@echo ""
	@echo "Or simply use 'make test' which handles this automatically."
	@echo "========================================="

clean:
	rm -rf roles/vendors/* collections/vendors/*
	molecule cleanup --all
	molecule destroy --all

test:
	export _MOLECULE_VAGRANT_PLUGIN_DIR="$(MOLECULE_VAGRANT_PLUGIN_DIR)" && \
	molecule test $(TEST_ARGS)
