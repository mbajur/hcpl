# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"

set :application, "hcpl"
set :repo_url, 'git@github.com:mbajur/hcpl.git'
set :deploy_to, "/mnt/disk/apps/#{fetch(:application)}"
