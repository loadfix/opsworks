# AWS OpsWorks Recipe for Wordpress to be executed during the Configure lifecycle phase
# - Creates the config file wp-config.php with MySQL data.
# - Creates a Cronjob.

Chef::Log.debug("Running wordpress configure...")

require 'uri'
require 'net/http'
require 'net/https'

uri = URI.parse("https://api.wordpress.org/secret-key/1.1/salt/")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)
keys = response.body

node[:deploy].each do |application, deploy|

  Chef::Log.debug("Node: #{deploy[:deploy_to]}")

  # Create the wordpress directory
  directory "#{deploy[:deploy_to]}/current/" do
    owner deploy[:user]
    group deploy[:group]
    mode 0755
    recursive true
  end

  template "#{deploy[:deploy_to]}/current/wp-config.php" do
    source "wp-config.php.erb"
    mode 0660
    owner deploy[:user]
    group deploy[:group]

    variables(
      :keys =>     (keys rescue nil),
      :host =>     (deploy[:database][:host] rescue nil),
      :user =>     (deploy[:database][:username] rescue nil),
      :password => (deploy[:database][:password] rescue nil),
      :database => (deploy[:database][:database] rescue nil)
    )
  end
end


# Create a Cronjob for Wordpress
cron "wordpress" do
  hour "*"
  minute "*/15"
  weekday "*"
  command "wget -q -O - http://localhost/wp-cron.php?doing_wp_cron >/dev/null 2>&1"
end
