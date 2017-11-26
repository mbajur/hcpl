#!/bin/sh -eu

# cat <<EOF >> $HOME/.ssh/config
#   User mbajur
#   ForwardAgent yes
# EOF

# Add the preferred key for getting GitHub Permission
# See https://circleci.com/gh/masutaka/masutaka.net/edit#checkout
# eval $(ssh-agent)
# ssh-add

# Fix host authenticity for host
# taken from https://discuss.circleci.com/t/capistrano-and-ssh-host-authenticity/13586/6
ssh-keyscan dokku.hcxp.co >> ~/.ssh/known_hosts

git remote add production dokku@dokku.hcxp.co:hcpl
git push production master
