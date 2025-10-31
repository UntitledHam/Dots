# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux


# Set-up FZF key bindings (CTRL R for fuzzy history finder)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

source $HOME/.profile


export PATH=$PATH:~/.cargo/bin/
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust 

### End of Zinit's installer chunk


zi snippet OMZL::clipboard.zsh
zi snippet OMZL::termsupport.zsh
zi snippet OMZL::git.zsh
zi snippet OMZL::theme-and-appearance.zsh 
zi snippet OMZL::prompt_info_functions.zsh
zi snippet OMZL::async_prompt.zsh
zi snippet OMZL::functions.zsh
zi snippet OMZL::misc.zsh
zi snippet OMZL::vcs_info.zsh



zi snippet OMZP::git
zi snippet OMZP::ruby
zi snippet OMZP::conda-env
zi snippet OMZP::sudo
zi snippet OMZP::colored-man-pages

# Auto suggestions:
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zi cdclear -q # <- forget completions provided up to this moment

zinit light Aloxaf/fzf-tab

# fzf keybinds:
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git" 
export FZF_CTRL_T_COMMAND="$FZF_DEFUALT_COMMAND"
export FZF_ALT_C_COMMAND="fd --typed --hidden --strip-cwd-prefix --exclude .git" 
export EDITOR="nvim"

_fzf_compgen_path() {
   fd --hidden --exclude .git . "$1" 
}
# Use fd to generate the list for directory completion.
_fzf_compgen_dir() {
   fd --type=d --hidden --exclude .git . "$1"
}


show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}
# IMPORTANT: kitty-scrollback.nvim only supports zsh 5.9 or greater for command-line editing,
# please check your version by running: zsh --version
# add the following environment variables to your zsh config (e.g., ~/.zshrc)
autoload -Uz edit-command-line
zle -N edit-command-line
function kitty_scrollback_edit_command_line() { 
  local VISUAL='/home/ham/.local/share/nvim/lazy/kitty-scrollback.nvim/scripts/edit_command_line.sh'
  zle edit-command-line
  zle kill-whole-line
}
zle -N kitty_scrollback_edit_command_line
bindkey '^x^e' kitty_scrollback_edit_command_line
# [optional] pass arguments to kitty-scrollback.nvim in command-line editing mode
# by using the environment variable KITTY_SCROLLBACK_NVIM_EDIT_ARGS
# export KITTY_SCROLLBACK_NVIM_EDIT_ARGS=''

# FZF Theme:
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Prompt
setopt promptsubst
zinit snippet OMZT::murilasso

eval "$(oh-my-posh --config=$HOME/.config/oh-my-posh/config.toml init zsh)"


eval "$(zoxide init --cmd cd zsh)"
eval "$(thefuck --alias)"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle 'fzf-tab:complete:cd:*' fzf-preview --preview='eza --tree --color=always $realPath'

source $HOME/.aliases
source $HOME/.private_zshrc

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/ham/.lmstudio/bin"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# End of LM Studio CLI section

autoload -U compinit; compinit
