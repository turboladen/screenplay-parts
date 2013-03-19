class RbEnv < Drama::Part
  def play(user: user)

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
      host.apt package: 'git', update_cache: true
    when :centos
      host.yum package: 'git', update_cache: true
    end

    # rbenv
    host.git repository: 'git://github.com/sstephenson/rbenv.git',
      destination: rbenv_home
    host.shell command: %[echo 'export PATH="#{rbenv_home}/bin:$PATH"' >> #{profile_file}]
    host.shell command: %[echo 'eval "$(rbenv init -)"' >> #{profile_file}]

    # ruby-build
    host.git repository: 'git://github.com/sstephenson/ruby-build.git',
      destination: "#{rbenv_home}/plugins/ruby-build"
  end
end
