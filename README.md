# Ubuntu-dev desktop

This is my Ubuntu workstation playbook.

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

Each machine is described by its inventory entry: per-host configuration (package lists, dotfiles, GNOME settings…) lives in `inventory/host_vars/<host>/vars.yml`, secrets live in Ansible Vault files (`inventory/group_vars/all/vault_vars.yml` plus per-host `vault_vars.yml` files), and host-specific extras that don't fit a role can be dropped into `playbooks/tasks/<host>/{root,user}/`, where the main playbook picks them up automatically.

The roles themselves are intentionally small and data-driven: they read those host_vars and apply them without hardcoding machine specifics.

## What does it require?

A Python `requirements.txt` file is provided. It includes the versiones of Ansible, related tools and libraries required to run the playbook.

If you also want to run tests locally, you'll need libvirt/KVM and the `hluaces.molecule` collection (vendored under `collections/vendors/`).

## File structure

```text
.
├── LICENSE
├── README.md                             # This file
├── Makefile                              # dependencies / test / provision targets
├── provision.sh                          # Bootstrap + run the playbook
├── requirements.txt                      # Python deps (ansible, molecule, lint)
├── renovate.json                         # Renovate bot configuration
├── ansible.cfg -> config/ansible.cfg     # Ansible.cfg file being used
├── config
│   ├── ansible.cfg                       # Ansible configuration
│   ├── ssh_config                        # SSH configuration
│   └── tmp                               # Runtime scratch (logs, retries)
├── inventory
│   ├── dev.ini                           # Scratch inventory for experiments
│   ├── prod.ini                          # Real machines (default)
│   ├── group_vars
│   │   ├── all.yml                       # Common variables to all hosts
│   │   └── all/vault_vars.yml            # Common secrets used by all hosts
│   └── host_vars/<host>/                 # Per-host config (vars.yml, vault_vars.yml)
├── molecule                              # Test scenarios (libvirt VMs)
├── playbooks
│   ├── files                             # Files used by the playbook
│   ├── tasks/<host>/{root,user}/         # Per-host extra tasks (auto-loaded)
│   ├── templates                         # Templates used by the playbook
│   └── ubuntu-install.yml                # The main playbook to use
├── plugins
│   └── callback                          # Custom stdout callback (anstomlog)
├── collections
│   ├── requirements.yml                  # External collections list
│   ├── local                             # Own collections (hluaces.iac/gnome/molecule)
│   └── vendors                           # Installed external collections (gitignored)
└── roles
    ├── requirements.yml                  # External roles list
    ├── local                             # Own standalone roles
    ├── profiles                          # Profile roles (empty placeholder)
    └── vendors                           # Installed external roles (gitignored)
```

## Quick Start

You'll need `git` and `python3` (3.10+) installed for this to work.

**Note:** If you have an older Python version (e.g., Python 3.8 on Ubuntu 20.04), you can downgrade Ansible in `requirements.txt` to a compatible version (e.g., `ansible==8.0.0` supports Python 3.9+).

After this:

- Clone this repo
- Replace `./inventory/group_vars/all/vault_vars.yml` with your own vaulted
  file (`ansible-vault create`), and make sure `vault_password_file` in
  `config/ansible.cfg` points at your vault password file
- Add or tweak an inventory entry in `./inventory/prod.ini` or `./inventory/dev.ini`
- Add or tweak the `./inventory/host_vars` of the host you want to provision
- If you want to run extra tasks save them inside `playbooks/tasks/<your-host>/root` or `playbooks/tasks/<your-host>/user`. They will be loaded automatically

## Run tests

Tests run via Molecule in executor mode, provisioning libvirt/KVM VMs using the vendored `hluaces.molecule` collection (cloud image + cloud-init). The runner must have libvirt/KVM available.

- Install all dependencies with `make dependencies`
- Run all scenarios with `make test`
- Run a specific scenario with `make test TEST_ARGS="-s ubuntu24-desktop"` or `make test TEST_ARGS="-s ubuntu24-laptop"`
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
