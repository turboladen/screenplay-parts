#   # A port of Opscode's MySQL Server Part could look something like:
class MySQLServer < Screenplay::Part
  # Define this here, or in some other file.  And use some other Ruby
  # feature other than a constant--it's up to you.
  PACKAGES = {
    debian: 'mysql-server',
    ubuntu: 'mysql-server',
    rhel: 'mysql-server',
    fedora: 'mysql-server',
    centos: 'mysql-server',
  }

  def play(root_group: 'root', root_password: root_password, conf_dir: '/etc/mysql', package: PACKAGES[host.distribution])
    case host.operating_system
    when :linux
      #case host.distribution
      #when :ubuntu
      preseeding_dir = '/var/cache/local/preseeding'
      preseeding_file = "#{preseeding_dir}/mysql-server.seed"

      host.shell.su do
        host.directory preseeding_dir, owner: 'root', group: root_group, mode: '755'

        host.file preseeding_file, owner: 'root', group: root_group, mode: '755',
          contents: lambda { |file|
            file.from_template('mysql-server.seed.erb', root_password: root_password)
          }

        host.packages.update_index
        host.packages.upgrade_packages
        host.packages[package].install
      end
      #when :centos
      # Etc
      #end
    when :darwin
      # Etc
    end
  end

  # Add any helper methods too, if you want to refactor #play...
end
