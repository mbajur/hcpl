server 'forum.hard-core.pl', user: 'mbajur', roles: %w(app db web)
set :branch, 'master'
set :capose_file, "docker-compose.#{fetch(:stage)}.yml"

set :capose_commands, -> {
  [
    "build --build-arg CACHEBUST=$(date +%s) web sidekiq",
    "run --rm web bundle exec rake db:create || true",
    "run --rm web bundle exec rake db:migrate",
    "up -d"
  ]
}
