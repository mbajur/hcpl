#!/bin/sh -eu

cat <<EOF >> $HOME/.ssh/config
  User mbajur
  ForwardAgent yes
EOF

# Add the preferred key for getting GitHub Permission
# See https://circleci.com/gh/masutaka/masutaka.net/edit#checkout
eval $(ssh-agent)
ssh-add

bundle exec cap production deploy
