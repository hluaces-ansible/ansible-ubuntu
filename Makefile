
dependencies:
	ansible-galaxy role install -f -r roles/requirements.yml -p roles/vendors
	ansible-galaxy collection install -f -r collections/requirements.yml -p collections/vendors

clean:
	rm -rf roles/vendors/* collections/vendors/*

test:
	cd vagrant && vagrant up --provision && cd .. || cd ..

destroy:
	cd vagrant && vagrant destroy -f && cd .. || cd ..
