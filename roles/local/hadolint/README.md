# Description

This role installs [Hadolint](https://github.com/hadolint/hadolint) to a customizable destination.

# OS compatibility

Tested with:

- Ubuntu 22
- Ubuntu 20

# System requisites

None.

# Ansible requisites

It depends on the module `ansible.builtin.get_url`.

# Configurable variables

- `hadolint_release`: Hadolint release to install. Use the name as it is on the remote repository (for example: `"v.2.10.0"`)
- `hadolint_install_dir`: path where Hadolint will be installed. Directory should exist
- `hadolint_mode`: Permissions for he copied file (default: `"0755"`)
- `hadolint_binary`: Binary file from the release to install (default: `"hadolint-Linux-x86_64"`)

# Tests

Run `molecule tests` to execute the test suite for this role.
