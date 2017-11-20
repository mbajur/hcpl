# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"

set :application, "hcpl"
set :repo_url, 'git@github.com:mbajur/hcpl.git'
set :deploy_to, "/mnt/disk/apps/#{fetch(:application)}"
set :ssh_options, keys: ["config/deploy_id_rsa"] if File.exist?("config/deploy_id_rsa")

task :uptime do
  on roles(:all) do |host|
    # execute :any_command, "with args", :here, "and here"
    # execute :'docker-compose', "-f docker-compose.production.yml run --rm web bundle exec rails c"
    # execute :ls, "-l"

    %x("ssh -l #{user} #{hostname} -t 'source ~/.profile && cd #{current_path} && docker-compose ps'")

    info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
  end
end
