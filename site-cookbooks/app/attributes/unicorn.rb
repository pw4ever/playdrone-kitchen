include_attribute 'app::shared'

default[:app][:unicorn][:port]     = 80
default[:app][:unicorn][:user]     = 'user'
default[:app][:unicorn][:password] = 'password'

default[:iptables][:services][:unicorn_http] = 80
