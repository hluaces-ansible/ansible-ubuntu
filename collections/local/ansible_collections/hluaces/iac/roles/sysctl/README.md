# Description

Sets up the `sysctl` configuration for a host from Ansible variables.

# Ansible requisites

The role leverages the `ansible.builtin.sysctl` module.

# Configurable variables

The role uses three variables with the same format:

- `sysctl_configuration`
- `sysctl_default_configuration`
- `sysctl_extra_configuration`

All of them define the `sysctl` configuration which will be applied to the host. Normally you'll want to use `sysctl_extra_configuration` as the rest of them are simply there to give the role some flexibility. Feel free to see how the role combines then so that you can override their values if needed.

The data structure for each one is a dictionary where each key is a `sysctl` value to modify (for example: `'fs.inotify.max_user_watches'`) and each value is another dictionary with an arbitrary set of parameters for the `ansible.builtin.sysctl` module.

An example below:

```yaml
---
sysctl_extra_configuration:
  'fs.inotify.max_user_watches':
    value: 524288
```

# Tests

Run `molecule test` to execute the unit tests for this role.
