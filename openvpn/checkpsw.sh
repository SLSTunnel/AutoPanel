#!/bin/bash

DB="/etc/autopanel/data/users.db"

hash=$(echo -n "$password" | sha256sum | awk '{print $1}')

grep -q "^$username:$hash$" $DB && exit 0 || exit 1
