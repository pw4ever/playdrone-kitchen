# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

Vagrant.configure("2") do |config|
  config.berkshelf.enabled = true

  #config.vm.box = "ubuntu/trusty64"
  config.vm.box = "hashicorp/precise64"
  config.vm.synced_folder "srv/", "/srv/"

  config.vm.define :node1 do |box|
    box.vm.provider(:virtualbox) do |vb|
      vb.name = 'playdrone01'
      box.vm.hostname = 'node1'
      #vb.customize ["modifyvm", :id, "--memory", 4096]
      vb.gui = true
      vb.memory = 4096
      #vb.cpus = 4
    end
    box.vm.network :private_network, ip: "10.1.1.11"
    box.vm.network :forwarded_port, guest: 8080, host: 8080 # Elastic search
    box.vm.network :forwarded_port, guest: 8000, host: 8000 # Graphite
    box.vm.network :forwarded_port, guest: 80,   host: 4000 # Application

    box.vm.provision :chef_solo do |chef|
      chef.roles_path = "roles"
      chef.run_list = [
        "recipe[system::hostname]",
        "recipe[system::timezone]",
        #"recipe[system::update_package_list]",
        #"recipe[system::upgrade_packages]",

        "recipe[rvm::system]",
        "recipe[rvm::vagrant]",

        "recipe[java]",
        "role[elasticsearch]",

        "recipe[nginx::default]",

        "recipe[statsd]",

        "role[collectd_graphite]",

        "recipe[app::unicorn]",
        "recipe[app::sidekiq]",
        "recipe[app::metrics]",
        "recipe[app::git-daemon]",
        #"recipe[iptables]",
      ]

      chef.json = {
        hostname: "playdrone01",

        system: {
          timezone: "UTC",
          short_hostname: "playdrone01",
          domain_name: "localdomain",
          static_hosts: {
            # collectd_graphite is deployed on monitor on port 2003
            "10.1.1.11" => "monitor",
          }
        },

        rvm: {
            # https://github.com/fnichol/chef-rvm/blob/master/attributes/default.rb
            default_ruby: "ruby-2.1",
            rubies: [
                {
                  'version' => 'ruby-2.1',
                  'ruby_string' => 'ruby-2.1',
                },
            ],
            group_users: ["root", "vagrant"],
            # https://github.com/fnichol/chef-rvm/issues/297
            install_rubies: true,
            # https://github.com/fnichol/chef-rvm/issues/299
            gpg: {
                homedir: "/root",
            },
            global_gems: [
                {name: "bundler"},
                {name: "chef"}, 
            ],
            rvmrc: {
              'rvm_project_rvmrc'             => 1,
              'rvm_gemset_create_on_use_flag' => 1,
              'rvm_trust_rvmrcs_flag'         => 1,
            },
        },

        java: {
          install_flavor: "openjdk",
          jdk_version: "7",
        },

        graphite: { 
          listen_port: 8000, 
          storage_schemas: [{ name: 'catchall', 
                              pattern: '^.*', 
                              retentions: '10s:3d', }] 
        },

        elasticsearch: {
          # to prevent permission complication
          uid: 0,
          gid: 0,

          nginx: { 
              users: [{username: "username", password: "password"}],
              ssl: {},
          },
          bootstrap: { mlockall: false },
          network: { publish_host: '10.1.1.11' },
          'discovery.zen.ping.unicast.hosts' => ['playdrone01'],
        },

        statsd: {
            # https://github.com/hectcastro/chef-statsd/issues/38
            nodejs_bin: "/usr/bin/node",
        },

        app: {
          nodes: ['playdrone01'],
          sidekiq: { market_threads: 4, bg_threads: 2 },
          unicorn: { user: "username", password: "password" },
        },
      }
    end
  end

  # config.vm.define :node2 do |box|
    # box.vm.provider(:virtualbox) do |vb|
      # vb.name = box.vm.hostname = 'node2'
      # vb.customize ["modifyvm", :id, "--memory", 2048]
    # end
    # box.vm.network :private_network, ip: "10.1.1.12"
    # box.vm.network :forwarded_port, guest: 8080, host: 8081 # Elastic search

    # box.vm.provision :chef_solo do |chef|
      # chef.roles_path = "roles"
      # chef.run_list = [
        # "recipe[hosts]",
        # "recipe[base]",
        # "recipe[time]",
        # "role[collectd_graphite]",
        # "role[elasticsearch]",
        # "recipe[ruby]",
        # "recipe[app::sidekiq]",
        # "recipe[app::metrics]",
      # ]

      # chef.json = {
        # hosts: {
          # 'monitor' => '10.1.1.11',
          # 'redis'   => '10.1.1.11',
          # 'node1'   => '10.1.1.11',
          # 'node2'   => '10.1.1.12'
        # },

        # elasticsearch: {
          # bootstrap: { mlockall: false },
          # network: { publish_host: '10.1.1.12' },
          # 'discovery.zen.ping.unicast.hosts' => ["node1", "node2"]
        # },
        # app: {
          # nodes: ['node1', 'node2'],
          # sidekiq: { market_threads: 4, bg_threads: 2 }
        # },
      # }
    # end
  # end
end
