#
# A theme based on Steve Losh's Extravagant Prompt with vcs_info integration.
#
# Authors:
#   Steve Losh <steve@stevelosh.com>
#   Bart Trojanowski <bart@jukie.net>
#   Brian Carper <brian@carper.ca>
#   steeef <steeef@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Screenshots:
#   http://i.imgur.com/HyRvv.png
#

function _update_ruby_version()
{
  typeset -g ruby_version=''
  if which rbenv &> /dev/null; then
    ruby_version="$(rbenv version | sed -e "s/ (set.*$//")"
  fi
}

function prompt_guiceolin_setup {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)

  # Load required functions.
  autoload -Uz vcs_info

  # Update ruby version on pwd change
  chpwd_functions+=(_update_ruby_version)
  _update_ruby_version()

  # Use extended color pallete if available.
  if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
    _prompt_guiceolin_colors=(
      "%F{81}"  # Turquoise
      "%F{166}" # Orange
      "%F{135}" # Purple
      "%F{161}" # Hotpink
      "%F{118}" # Limegreen
    )
  else
    _prompt_guiceolin_colors=(
      "%F{cyan}"
      "%F{yellow}"
      "%F{magenta}"
      "%F{red}"
      "%F{green}"
    )
  fi

  # Formats:
  #   %b - branchname
  #   %u - unstagedstr (see below)
  #   %c - stagedstr (see below)
  #   %a - action (e.g. rebase-i)
  #   %R - repository path
  #   %S - path in the repository
  local branch_format="(${_prompt_guiceolin_colors[1]}%b%f%u%c)"
  local action_format="(${_prompt_guiceolin_colors[5]}%a%f)"
  local unstaged_format="${_prompt_guiceolin_colors[2]}●%f"
  local staged_format="${_prompt_guiceolin_colors[5]}●%f"

  # Set vcs_info parameters.
  zstyle ':vcs_info:*' enable bzr git hg svn
#  zstyle ':vcs_info:*:prompt:*' check-for-changes true
  zstyle ':vcs_info:*:prompt:*' unstagedstr "${unstaged_format}"
  zstyle ':vcs_info:*:prompt:*' stagedstr "${staged_format}"
  zstyle ':vcs_info:*:prompt:*' actionformats "${branch_format}${action_format}"
  zstyle ':vcs_info:*:prompt:*' formats "${branch_format}"
  zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

  # Define prompts.
  PROMPT="${_prompt_guiceolin_colors[3]}%n%f at ${_prompt_guiceolin_colors[2]}%m%f in ${_prompt_guiceolin_colors[5]}%~%f "'${vcs_info_msg_0_}'"
$ "
  RPROMPT="%F{red}[$(ruby_version)]"
}

prompt_guiceolin_setup "$@"
