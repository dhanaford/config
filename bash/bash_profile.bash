# Color files and directories
alias ls="ls -G"

# Display human-readable file sizes in a long format
alias ll="ls -hl"

# Display human-readable file sizes, including all files, in a long format
alias la="ls -hal"

# Go back a directory
alias ..="cd .."

# Set the default editor to Atom for bash (i.e. instead of vim)
export EDITOR="atom -w"

# Helper function to get the current git branch
_get_current_git_branch() {
  git symbolic-ref --short HEAD 2> /dev/null
}

# Helper function to check if the current git directory's staging area is dirty
_is_git_dirty() {
  git status --short --ignore-submodules=dirty 2> /dev/null
}

# Helper function to set the prompt
_set_prompt() {
  # Store the exit code of the last command
  local status=$?

  # Store bash color codes for convenience
  local blue="\[\033[0;34m\]"
  local green="\[\033[0;32m\]"
  local purple="\[\033[0;35m\]"
  local red="\[\033[0;31m\]"
  local reset="\[\033[0;0m\]"
  local yellow="\[\033[0;33m\]"

  # If the last command's exit code was zero (i.e. success)
  if [[ $status -eq 0 ]]; then

    # Add the current working directory to the prompt in blue
    PS1="$blue\w "

  # Other the last command's exit code was non-zero (i.e. failure)
  else

    # Add the current working directory to the prompt in red
    PS1="$red\w "
  fi

  # Store the current git branch
  local branch=$(_get_current_git_branch)

  # If a current git branch exists
  if [[ -n $branch ]]; then

    # Add the current git branch to the prompt in yellow
    PS1="$PS1$yellow$branch "

    # If the current git directory's staging area is dirty
    if [[ -n $(_is_git_dirty) ]]; then

      # Store the cross character
      local cross="✖"

      # Add the cross to the prompt in red
      PS1="$PS1$red$cross "

    # Otherwise the current git directory's staging area is not dirty
    else

      # Store the check character
      local check="✔"

      # Add the check to the prompt in green
      PS1="$PS1$green$check "
    fi

  # Otherwise a current git branch does not exist
  else

    # Add the dollar sign to the prompt in purple
    PS1="$PS1$purple\$ "
  fi

  # Add the reset color to the prompt
  PS1="$PS1$reset"
}

# Run this function every time bash wants to print a new prompt to the screen
PROMPT_COMMAND=_set_prompt
