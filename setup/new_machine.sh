# Copy paste this file in bit by bit.
# Don't run it.

echo "Do not run this script in one go."
echo "Source this file and run the functions as needed. Hit Ctrl-C NOW"
read -n 1

###############################################################################
# Backup old machine's dotfiles                                               #
###############################################################################

function backup {

    mkdir -p ~/migration/home
    cd ~/migration

    # then compare brew-list to what's in `brew.sh`
    #   comm <(sort brew-list.txt) <(sort brew.sh-cleaned-up)

    # let's hold on to these

    cp ~/.extra ~/migration/home
    cp ~/.z ~/migration/home
    cp -R ~/.ssh ~/migration/home
    cp /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist ~/migration  # wifi
    cp ~/Library/Preferences/net.limechat.LimeChat.plist ~/migration
    cp ~/Library/Preferences/com.tinyspeck.slackmacgap.plist ~/migration
    cp -R ~/Library/Services ~/migration # automator stuff
    cp -R ~/Documents ~/migration
    cp ~/.bash_history ~/migration # back it up for fun?
    cp ~/.gitconfig.local ~/migration
    cp ~/.z ~/migration # z history file.

    # sublime text settings
    cp "~/Library/Application Support/Sublime Text 3/Packages" ~/migration


    # iTerm settings.
    # Prefs, General, Use settings from Folder

    # Finder settings
}


###############################################################################
# XCode Command Line Tools                                                    #
###############################################################################

function install_xcode_cli() {
    if ! xcode-select --print-path &> /dev/null; then

    # Prompt user to install the XCode Command Line Tools
    xcode-select --install &> /dev/null

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait until the XCode Command Line Tools are installed
    until xcode-select --print-path &> /dev/null; do
        sleep 5
    done

    print_result $? 'Install XCode Command Line Tools'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Point the `xcode-select` developer directory to
    # the appropriate directory from within `Xcode.app`
    # https://github.com/alrra/dotfiles/issues/13

    sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
    print_result $? 'Make "xcode-select" developer directory point to Xcode'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Prompt user to agree to the terms of the Xcode license
    # https://github.com/alrra/dotfiles/issues/10

    sudo xcodebuild -license
    print_result $? 'Agree with the XCode Command Line Tools licence'

    fi
}


###############################################################################
# Homebrew                                                                    #
###############################################################################

function install_homebrew {

    $HOME/dotfiles/install/brew.sh
    $HOME/dotfiles/install/brew-cask.sh

}


###############################################################################
# Node                                                                        #
###############################################################################

# Must run `install_homebrew` first
function install_node {
    $HOME/dotfiles/install/node.sh
}


###############################################################################
# Git                                                                         #
###############################################################################

# github.com/jamiew/git-friendly
# the `push` command which copies the github compare URL to my clipboard is heaven
function install_git_friendly {
    bash < <( curl https://raw.githubusercontent.com/jamiew/git-friendly/master/install.sh)
}


###############################################################################
# Z                                                                           #
###############################################################################

# github.com/rupa/z - hooked up in .zshrc
# consider reusing your current .z file if possible. it's painful to rebuild :)
# or use autojump instead https://github.com/wting/autojump
function install_z {
    git clone https://github.com/rupa/z.git ~/z
    chmod +x ~/z/z.sh
}

function install_pygments {
  # for the c alias (syntax highlighted cat)
  sudo easy_install Pygments
}


###############################################################################
# OSX defaults                                                                #
# https://github.com/hjuutilainen/dotfiles/blob/master/bin/osx-user-defaults.sh
###############################################################################

function run_macos_script {
    sh .macos
}


###############################################################################
# Symlinks to link dotfiles into ~/                                           #
###############################################################################

function run_setup_script {
    ./setup.sh
}
