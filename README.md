# Ubuntu-dev desktop

This is my Ubuntu 18/19/20 workstation playbook.

Its purposes are:

- Document everything that I use on my workstation.
- Keep track of my preferences on a git repository.
- Ease the deployment of a new workstation or the upgrade of the current one.

## What does it do?

Basically it does this:

- Self-installs the `ansible-galaxy` requirements.
- Creates a new user which will be flagged as a sudoer.
- Installs a bunch of software from several package managers:
    - apt
    - pip
    - npm
- Deploys my Thunderbird configuration.
- Deploys my `.dotfiles` to both root and the newly created user.
- Installs a bunch of software.
- Configures Gnome preferences and privacy settings to my liking.
- Installs a few extra things.

## How does it do it?

A single configuration file in `config/config.yml` keeps track of all the packages and configurations that will be done.

As you can see, every role on this repository is pretty minimalistic as the main idea behind this aproach is to have my settings saved on a single `.yml` file that could be fed to the roles without changing its programming at all. If I were to need a change on my setup a simple modification on the configuration file would do the trick.

That's the reason as to why some of these roles seem pretty basic: they indeed are, but are coded in a way that allow me to declare on a yaml file my requirements.

## File structure

```
.
├── LICENSE
├── README.md                             # This file
├── ansible.cfg -> config/ansible.cfg     # Ansible.cfg file being used
├── config                                # Configuration directory
│   ├── ansible.cfg                       # Ansible configuration
│   ├── known_hosts                       # Custom known_hosts file
│   ├── ssh_config                        # SSH configuration
│   ├── tmp                               # Temporary files
│   └── vault_secrets.yml                 # Vaulted variables crypted file
├── group_vars                            # Group vars directory
│   └── all/
|       └── vault_vars.yml                # Common secrets used by all hosts
│   └── all.yml                           # Common variables to all hosts
├── host_vars                           # Host vars directory
├── inventory                           # Inventory directory
│   ├── default.ini -> dev.ini            # Default inventory to use
│   ├── dev.ini                           # Dev inventory (vagrant)
│   └── prod.ini                          # Production inventory (localhost)
├── playbooks                           # Playbook directory
│   ├── files                             # Files used by the playbook
│   ├── tasks                             # Extra tasks ran by the playbook
│   │   ├── user                            # Unprivileged extra tasks
│   │   └── root                            # Privileged extra tasks
│   ├── templates                         # Templates used by the playbook
│   ├── 0_local_requirements.yaml         # Internal playbook.
│   └── ubuntu-install.yml                # The main playbook to use
├── plugins                             # Plugin directory
│   ├── action                            # Action plugins
│   ├── callback                          # Callback plugins
│   ├── connection                        # Connection plugins
│   ├── filter                            # Filter plugins
│   ├── lookup                            # Lookup plugins
│   ├── modules                           # Modules plugins
│   └── vars                              # Vars plugins
└── roles                               # Roles directory
    ├── local                             # Locale roles
    ├── profiles                          # Profile roles
    ├── requirements.yml                  # Vendor roles list
    └── vendors                           # Vendor roles
```

## Quick Start

You'll need `git` and `ansible` installed for this to work. Also, this is used to provision an Ubuntu machine from the ones defined in the inventory files. You are supposed to install it first if you want to provision a live environment.

After this:

- Clone this repo.
- Delete the `./inventory/group_vars/all/vault_secrets.yml` file and create yours.
- Add or tweak and inventory entry in `./inventory/prod.ini` or `./inventory/dev.ini`.
- Add or tweak the `./inventory/host_vars` of the host you want to provision.
- If you want to run extra tasks save them either inside the `playbooks/tasks/root` directory or inside `playbooks/tasks/user`. They will be loaded automatically.

## Run the playbook against a self-provisioning testing environment

This assumes that you have both Virtualbox and Vagrant installed on your machine.

Before doing this you might need to run the `playbooks/0_local_requirements.yml` playbook in order to install local Ansible-galaxy dependencies.

As it only targets `localhost`  you can simply execute it with the following command:

```
ansible-playbook -vv playbooks/0_local_requirements.yml
```

To create and provision a new environment:

```
cd vagrant
vagrant up
```

To reprovision an already created environment:

```
cd vagrant
vagrant provision
```

If you want to destroy the newly created testing environment:

```
cd vagrant
vagrant destroy
```

## Run the playbook against your local machine (production)

You'll need to run this as a sudoer.

```
ansible-playbook -kK -v -i inventory/prod.ini playbooks/ubuntu-install.yml -l laptop
```

## License

Please read [GNU AFFERO GENERAL PUBLIC LICENSE](LICENSE).

## Credits

This playbook's structure is based on the superb [ansible-skel by mrjk](https://github.com/mrjk/ansible-skel).

I'm also using [geerlingguy's amazing Docker role](https://github.com/geerlingguy/ansible-role-docker) from Ansible Galaxy.

The rest of it comes from my own experience, which is influenced by Ansible's community, my colleagues and Sigmar allmighty.
