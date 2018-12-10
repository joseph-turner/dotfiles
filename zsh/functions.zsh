# =============================================================================
#                                   Functions
# =============================================================================

powerlevel9k_random_color(){
	local code
	#for code ({000..255}) echo -n "$%F{$code}"
	#code=$[${RANDOM}%11+10]    # random between 10-20
	code=$[${RANDOM}%211+20]    # random between 20-230
	printf "%03d" $code
}

zsh_wifi_signal(){
	local signal=$(nmcli -t device wifi | grep '^*' | awk -F':' '{print $6}')
    local color="yellow"
    [[ $signal -gt 75 ]] && color="green"
    [[ $signal -lt 50 ]] && color="red"
    echo -n "%F{$color}\uf1eb" # \uf1eb is 
}

# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "$_";
}

# List all files, long format, colorized, permissions in octal
function la(){
 	ls -l  "$@" | awk '
    {
      k=0;
      for (i=0;i<=8;i++)
        k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));
      if (k)
        printf("%0o ",k);
      printf(" %9s  %3s %2s %5s  %6s  %s %s %s\n", $3, $6, $7, $8, $5, $9,$10, $11);
    }'
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
  cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Compare original and gzipped file size
function gz() {
  local origsize=$(wc -c < "$1");
  local gzipsize=$(gzip -c "$1" | wc -c);
  local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
  printf "orig: %d bytes\n" "$origsize";
  printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

function update() {
  echo "Updated and cleaning up homebrew stuff"
  brew update && brew upgrade && brew prune && brew cleanup;

  echo "Installing latest LTS version of Node"
  nvm install --lts
}

function wallpapers() {

  # Check flags
  while getopts ":d:t:" opt; do
    case ${opt} in
      # --help | -h)
      #   helpmenu
      #   exit
      #   ;;
      --directory | --dir | d )
        # echo "Directory is $OPTARG" >&2
        local wp_dir=$OPTARG
        ;;
      --duration | --dur | t )
        # Duration of wallpaper cycle (default 5 min)
        local wp_dur=$OPTARG
        ;;
      \? )
        echo "Invalid option -$OPTARG" 1>&2
        exit 1
    esac
  done
  shift $((OPTIND -1))

  echo $wp_dir
  echo $wp_dur

  # Set some kind of time out for the duration that changes the wallpaper
  # TODO: download images to temp folder with data.

  # unset wp_dir
  # unset wp_dur

  # sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '$1'" && killall Dock
}
