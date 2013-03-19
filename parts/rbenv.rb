class RbEnv < Drama::Part
  def act(user: user)

    #if remote_os.osx?
      brew formula: 'git', state: :installed, update: true
      brew formula: 'rbenv', state: :installed
      brew formula: 'ruby-build', state: :installed
      return
    #end

    profile_file = # if remote_os.ubuntu?
      '~/.profile'
    #elsif remote_shell.zsh?
    #  '~/.zshrc'
    #else
    #  '~/.bash_profile'
    #end

    rbenv_home = "/home/#{user}/.rbenv"

    # git
    apt package: 'git', state: :installed, update_cache: true

    # rbenv
    #git repo: 'git://github.com/sstephenson/rbenv.git', dest: rbenv_home
    #shell %[echo 'export PATH="#{rbenv_home}/bin:$PATH"' >> #{profile_file}]
    #shell %[echo 'eval "$(rbenv init -)"' >> #{profile_file}]

    # ruby-build
    #git repo: 'git://github.com/sstephenson/ruby-build.git',
    #  dest: "#{rbenv_home}/plugins/ruby-build"
  end
end
