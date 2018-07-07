
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
  
# Enable php-fpm
service 'php-fpm' do
  action :enable
end
  
# Start php-fpm
service 'php-fpm' do
  action :start
end