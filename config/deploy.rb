set :application, "ieema"
set :repo_name, "ieema"
set :stage, "production"
set :deploy_to, "/u/#{application}"
set :user, application
set :repository, "http://svn.risingsuntech.net/#{repo_name}/"
set :deploy_via, :remote_cache
set :rails_env, 'production'
set :db_user, "#{application}_db"
set :group, "deploy"
set :scm_username, "deploy"
set :scm_password, proc { Capistrano::CLI.password_prompt("Subversion Password : ") }
set :db_passwd, proc { Capistrano::CLI.password_prompt("Production database remote Password : ") }

set :domain, "sunday"
set :domains, ["ieema.risingsunapps.com"]

ssh_options[:user] = "ieema"
ssh_options[:port] = 22001
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "ieema@sunday")]

role :app, domain, :primary => true
role :web, domain
role :db, domain, :primary => true

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

desc "After updating code we need to populate a new database.yml"
task :make_database_yaml, :roles => :app do
  require "yaml"
  #set :production_database_password, proc { Capistrano::CLI.password_prompt("Production database remote Password : ") }
  database_file = YAML::load_file('config/database.yml.tmp')
  # get rid of uneeded configurations
  database_file.delete('test')
  database_file.delete('development')

  # Populate production element
  database_file['production']['adapter'] = "mysql"
  database_file['production']['database'] = "#{application}_production"
  database_file['production']['username'] = db_user
  database_file['production']['password'] = db_passwd
  database_file['production']['socket'] = "/var/run/mysqld/mysqld.sock"
  database_file['production']['encoding'] = "utf8"
  put YAML::dump(database_file), "#{shared_path}/config/database.yml", :mode => 0664
end

desc "After updating conde we need to link config file from shared"
task :symlink_files, :roles => :app do
  ['database.yml'].each do |file|
    run "ln -fs #{shared_path}/config/#{file} #{release_path}/config"
  end
end

after "deploy:update_code", "make_database_yaml", "symlink_files"
after "deploy:setup", "add:folders", "nginx:virtual_host:create"
#after "deploy:restart"# ,"nginx:virtual_host:enable"#, "nginx:reload"

set :nginx_script_name, "#{application}_host_conf"
set :nginx_file_path, "/usr/local/nginx/sites-available/#{nginx_script_name}"

namespace :add do
  desc "Adding relevant deployment folders"
  task :folders, :roles => :app do 
    run "sudo mkdir -p #{shared_path}/config #{shared_path}/index" 
    run "sudo chown #{user}:#{group} #{deploy_to} -R" 
  end
end

namespace :nginx do
  desc "Reload nginx settings"
  task :reload, :roles => :web do
    run "sudo /etc/init.d/nginx reload"
  end

  desc "Restart nginx"
  task :restart, :roles => :web do
    run "sudo /etc/init.d/nginx restart"
  end


  namespace :virtual_host do
    desc "Create a new virtual host"
    task :create, :roles => :app, :only => {:primary => true} do
      require 'erb'
      upload_path = "#{shared_path}/nginx"
      template = File.read("config/templates/nginx_virtual_host.erb")
      file = ERB.new(template).result(binding)
      put file, upload_path, :mode => 0644
      run <<-EOF
        sudo cp #{upload_path} #{nginx_file_path}
      EOF
    end

    desc "Enable a virtual host"
    task :enable, :roles => :web do
      sudo "ln -fs /usr/local/nginx/sites-available/#{nginx_script_name} /usr/local/nginx/sites-enabled/#{nginx_script_name}"
    end

    desc "Destroy a virtual host"
    task :destroy, :roles => :web do
      nginx.virtual_host.disable
      run "sudo rm /usr/local/nginx/sites-available/#{nginx_script_name}"
    end

    desc "Disable a virtual host"
    task :disable, :roles => :web do
      sudo "rm /usr/local/nginx/sites-enabled/#{nginx_script_name}"
    end
  end
end



desc "Install the production_log_analyzer"
task :install_syslog_gems, :roles => :app do
  sudo 'gem install production_log_analyzer'
  sudo 'gem install rails_analyzer_tools'
end

#desc "Installs the syslog filter"
#task :install_syslog_filter, :roles => :app do
#  sudo %{echo "!#{application} *.* #{shared_path}/log/#{rails_env}.log" >> /etc/syslog.conf}
#  sudo "/etc/init.d/sysklogd restart" # works for Ubuntu
#end

desc "Install Log Rotate Script"
task :install_log_rotate_script, :roles => :app do
  rotate_script = %Q{#{shared_path}/log/#{rails_env}.log {
  daily
  rotate 28
  notifempty
  missingok
  compress
  size 5M
  copytruncate
}}
  put rotate_script, "#{shared_path}/logrotate_script"
  sudo "cp #{shared_path}/logrotate_script /etc/logrotate.d/#{application}"
  sudo "rm #{shared_path}/logrotate_script"
end

set :log_email_recipient, "arun.agrawal@risingsuntech.net"

desc "Analyze production log and email results"
task :analyze_logs, :roles => :app do
  sudo %Q{chmod a+r #{shared_path}/log/*.gz}
  run %Q{for file in #{shared_path}/log/*.gz; \
         do gzip -dc "$file" | \
         pl_analyze /dev/stdin -e #{log_email_recipient}; \
         done}
end
