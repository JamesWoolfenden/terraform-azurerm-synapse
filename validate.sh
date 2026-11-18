#!/usr/bin/env bash
tofu fmt --recursive
cd example/examplea || return
rm .terraform.lock.hcl 2>/dev/null
rm .tofu -fr 2>/dev/null
tofu init -upgrade
tofu validate
make cost
make valid
