ANSIBLE_ARGS=
VAGRANT_BOX="ubuntu24-desktop"

dependencies:
	pip3 install -r requirements.txt
	ansible-galaxy role install -r roles/requirements.yml -p roles/vendors
	ansible-galaxy collection install -r collections/requirements.yml -p collections/vendors

clean:
	rm -rf roles/vendors/* collections/vendors/*

test:
	molecule converge

clean:
	molecule destroy
