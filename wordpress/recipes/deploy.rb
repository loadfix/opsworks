
node[:deploy].each do |application, deploy|

    ruby_block "install_wordpress" do
        block do
            require 'fileutils'
            FileUtils.cd "#{deploy[:deploy_to]}/current/"
            system 'wget https://wordpress.org/latest.tar.gz'
            system 'tar -xzf latest.tar.gz --strip-components=1 && rm latest.tar.gz'
        end
    end

    template "/etc/nginx/conf.d/wordpress.conf" do
        source "wordpress.conf.erb"
        mode 0640
        owner "root"
        group "root"
    end

    # Start nginx
    service 'nginx' do
        action :restart
    end
end