include_recipe "collectd"

collectd_plugin "cpu"
collectd_plugin "disk"
collectd_plugin "memory"

collectd_plugin "interface" do
  options :interface=>"lo", :ignore_selected=>true
end

collectd_plugin "df" do
  options(:report_reserved=>false,
          "FSType"=>["proc", "sysfs", "fusectl", "debugfs", "securityfs", "devtmpfs", "devpts", "tmpfs"],
          :ignore_selected=>true)
end

collectd_plugin "syslog" do
  options :log_level=>"Info"
end

collectd_plugin "write_graphite" do
  template 'write_graphite.erb'
end
