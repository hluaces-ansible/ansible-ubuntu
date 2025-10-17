# Ubuntu-dev desktop

This is my Ubuntu 18/19/20 workstation playbook.

Its purposes are:

- Document everything that I use on my workstation
- Keep track of my preferences on a git repository
- Ease the deployment of a new workstation or the upgrade of the current one

## What does it do?

Basically it does this:

- Self-installs the `ansible-galaxy` requirements
- Creates a new user which will be flagged as a sudoer
- Installs a bunch of software from several package managers:
    - apt
    - pip
    - npm
- Deploys my `.dotfiles` to both root and the newly created user
- Installs a bunch of software
- Configures Gnome preferences and privacy settings to my liking
- Installs a few extra things

## How does it do it?

A single configuration file in `config/config.yml` keeps track of all the packages and configurations that will be done.

As you can see, every role on this repository is pretty minimalistic as the main idea behind this aproach is to have my settings saved on a single `.yml` file that could be fed to the roles without changing its programming at all. If I were to need a change on my setup a simple modification on the configuration file would do the trick.

That's the reason as to why some of these roles seem pretty basic: they indeed are, but are coded in a way that allow me to declare on a yaml file my requirements.

## What does it require?

A Python `requirements.txt` file is provided. It includes the versiones of Ansible, related tools and libraries required to run the playbook.

If you also want to run tests locally, you'll need `vagrant`.

## File structure

```
.
├── LICENSE
├── README.md                             # This file
├── ansible.cfg -> config/ansible.cfg     # Ansible.cfg file being used
├── requirements.txt                      # Contains Python and Ansible
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
├── host_vars                             # Host vars directory
├── inventory                             # Inventory directory
│   ├── default.ini -> dev.ini            # Default inventory to use
│   ├── dev.ini                           # Dev inventory (vagrant)
│   └── prod.ini                          # Production inventory (localhost)
├── molecule                              # Used by the tests
├── playbooks                             # Playbook directory
│   ├── files                             # Files used by the playbook
│   ├── tasks                             # Extra tasks ran by the playbook
│   │   ├── <host1>                       # Extra tasks for Host1
│   │   │   ├── user                      # Unprivileged tasks for host1
│   │   │   └── root                      # Privileged taks for host1
│   │   ├── <...>                         # Extra tasks for other hosts
│   │   └── <hostN>                       # Extra tasks for other hosts
│   ├── templates                         # Templates used by the playbook
│   ├── 0_local_requirements.yaml         # Internal playbook.
│   └── ubuntu-install.yml                # The main playbook to use
├── plugins                               # Plugin directory
│   ├── action                            # Action plugins
│   ├── callback                          # Callback plugins
│   ├── connection                        # Connection plugins
│   ├── filter                            # Filter plugins
│   ├── lookup                            # Lookup plugins
│   ├── modules                           # Modules plugins
│   └── vars                              # Vars plugins
└── roles                                 # Roles directory
    ├── local                             # Locale roles
    ├── profiles                          # Profile roles
    ├── requirements.yml                  # Vendor roles list
    └── vendors                           # Vendor roles
```

## Quick Start

You'll need `git` and `python3` (3.10+) installed for this to work.

**Note:** If you have an older Python version (e.g., Python 3.8 on Ubuntu 20.04), you can downgrade Ansible in `requirements.txt` to a compatible version (e.g., `ansible==8.0.0` supports Python 3.9+).

After this:

- Clone this repo
- Delete the `./inventory/group_vars/all/vault_secrets.yml` file and create yours
- Add or tweak an inventory entry in `./inventory/prod.ini` or `./inventory/dev.ini`
- Add or tweak the `./inventory/host_vars` of the host you want to provision
- If you want to run extra tasks save them either inside the `playbooks/tasks/root` directory or inside `playbooks/tasks/user`. They will be loaded automatically

## Run tests

- Install Vagrant and Virtualbox
- Install all dependencies with `make dependencies`
- Run tests with `make test` (runs all scenarios)
- Run specific scenario with `make test MOLECULE_ARGS="-s ubuntu24-laptop"`
- Use `make clean` when you are done to clean up the environment

## Run the playbook against your local machine (production)

**Simple method:**
```bash
./provision.sh
```

Or using make:
```bash
make provision
```

To run in check mode without making changes:
```bash
make provision-check
```

**Manual method** (if you need more control):
```bash
# Create virtualenv
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
ansible-galaxy role install -r roles/requirements.yml -p roles/vendors
ansible-galaxy collection install -r collections/requirements.yml -p collections/vendors

# Run playbook
ansible-playbook -i inventory/prod.ini playbooks/ubuntu-install.yml --ask-become-pass
```

## License

Please read [GNU AFFERO GENERAL PUBLIC LICENSE](LICENSE).

## Credits

This playbook's structure is based on the superb [ansible-skel by mrjk](https://github.com/mrjk/ansible-skel).

I'm also using [geerlingguy's amazing Docker role](https://github.com/geerlingguy/ansible-role-docker) from Ansible Galaxy.

The rest of it comes from my own experience, which is influenced by Ansible's community, my colleagues and Sigmar allmighty.
