
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