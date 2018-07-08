
# Install nginx
package 'nginx' do
  action :install
end

# Enable nginx
service 'nginx' do
  action :enable
end

# Start nginx
service 'nginx' do
  action :start
end

# Install php-fpm
package 'php-fpm' do
  action :install
end

# Install php-mysql
package 'php-mysql' do
    action :install
  end
  
# Enable php-fpm
service 'php-fpm' do
  action :enable
end

# Configure php as user nginx

ruby_block "configure_php" do
    block do
        system 'sed -i "s/user = apache/user = nginx/g" /etc/php-fpm.d/www.conf'
        system 'sed -i "s/group = apache/group = nginx/g" /etc/php-fpm.d/www.conf'
    end
end

# Start php-fpm
service 'php-fpm' do
  action :start
end