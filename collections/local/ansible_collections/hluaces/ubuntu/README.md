# hluaces.ubuntu

Provisioning roles for my Ubuntu workstations ("laptop as code").

One flat collection: every role does exactly one concrete thing (one app,
one system concern). Hosts differ only via `host_vars`. Roles migrate here
from `roles/local/`, `hluaces.iac` and `hluaces.gnome`; see the repository
history for the migration sequence.

Not published to Galaxy (yet); consumed in-repo via `collections/local` on
the collections path.
