require 'atk_toolbox'

if OS.is?(:windows)
    raise <<-HEREDOC.remove_indent
        
        
        It appears you are trying to install ASDF on a windows machine
        Sadly Windows is not natively supported by ASDF
        
        However, you can install an Ubuntu WSL on Windows and this installation
        should work within that Ubuntu WSL
    HEREDOC
end


def safe_system(*args)
    system(*args)
    if not $?.success?
        raise <<-HEREDOC.remove_indent
            
            
            System Command Failed: #{args}
        HEREDOC
    end
end


# 
# install the executables
# 
Console.ok("installing asdf executable")
if OS.is?(:mac)
    system("brew install asdf --HEAD") || safe_system("brew upgrade asdf")
else
    safe_system "git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.6"
end

# 
# setup the profiles
#
if OS.is?(:mac)
    what_to_add = <<-HEREDOC
    
        . $(brew --prefix asdf)/asdf.sh
        . $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash
    HEREDOC
else
    what_to_add = <<-HEREDOC
    
        . $HOME/.asdf/asdf.sh
        . $HOME/.asdf/completions/asdf.bash
    HEREDOC
end
# for adding to bash profiles and such
profile_helper = FS::ProfileHelper.new("atk-asdf -- 230948032")
profile_helper.add_to_bash_profile(what_to_add)
profile_helper.add_to_zsh_profile(what_to_add)
profile_helper.add_to_bash_rc(what_to_add)
profile_helper.add_to_zsh_rc(what_to_add)

# FUTURE: add fish shell support
# touch ~/.config/fish/config.fish
# echo "set -gx PATH \$PATH <path>" >> ~/.config/fish/config.fish

# FUTURE: add a shell check to see if the user is using bash/zsh


# 
# install plugin helpers
# 
if OS.is?(:mac)
    system "brew install coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc unzip curl"
elsif OS.is?(:debian)
    system "sudo apt-get install -y automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev unzip curl"
else
    Console.keypress(<<-HEREDOC.remove_indent, keys: [ :return])
        
        Hey, so I'm pretty sure you're using non-debian linux, so you probably know what you're doing.
        
        Here's what debian normally needs to install:
            #{"sudo apt install automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev unzip curl".color_as :code}
        
        If you can install the equivlent of that on your system you should be all good for getting #{"asdf".color_as :keyword} working
        
        [Press enter to continue]
    HEREDOC
end

puts "==================================="
puts "         process complete"
puts "==================================="