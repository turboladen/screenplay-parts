class RbEnv < Screenplay::Part
  def play(user: user, binary: '/usr/bin/env rbenv', ruby_version: nil, remove: false)
    if remove
      remove_rvm(user)
      return
    end

    if host.env.operating_system == :darwin
      host.brew formula: 'git', state: :installed, update: true
      host.brew formula: 'rbenv', state: :installed
      host.brew formula: 'ruby-build', state: :installed
      return
    end

    profile_file = if host.env.distribution == :ubuntu
      '~/.profile'
    elsif host.env.shell == :zsh
      '~/.zshrc'
    else
      '~/.bash_profile'
    end

    rbenv_home = "/home/#{user}/.rbenv"

    # git
    case host.env.distribution
    when :ubuntu
      host.apt package: 'git', update_cache: true, sudo: true
    when :centos
      host.yum package: 'git', update_cache: true, sudo: true
    end

    # rbenv
    host.git repository: 'git://github.com/sstephenson/rbenv.git',
      destination: rbenv_home
    host.shell command: %[echo 'export PATH="#{rbenv_home}/bin:$PATH"' >> #{profile_file}]
    host.shell command: %[echo 'eval "$(rbenv init -)"' >> #{profile_file}]

    # ruby-build
    host.git repository: 'git://github.com/sstephenson/ruby-build.git',
      destination: "#{rbenv_home}/plugins/ruby-build"

    # Install ruby
    if ruby_version
      host.shell command: %[#{binary} versions | grep #{ruby_version}], on_fail: -> do
        host.shell command: %[#{binary} install #{ruby_version}]
      end
    end
  end

  def remove_rvm(user)
    case host.env.operating_system
    when :darwin
      host.brew formula: 'rbenv', state: :removed
      host.brew formula: 'ruby-build', state: :removed
    when :linux
      host.directory path: "/home/#{user}/.rbenv", state: :absent
    end
  end
end
