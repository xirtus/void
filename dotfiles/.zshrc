# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh path and theme
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git)
source $ZSH/oh-my-zsh.sh

# User-defined functions
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Correct Void Linux Plugin Paths (Sourced once)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
alias update='sudo xbps-install -Syu'
alias install='sudo xbps-install -S'
alias remove='sudo xbps-remove -R'
alias ..='cd ..'
alias ...='cd ../..'
alias vconf='nano ~/.config/river/init'
alias zconf='nano ~/.zshrc'
alias fetch='neofetch'
alias ls='ls --color=auto'

# Zsh-autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Keybindings
bindkey '^[[C' forward-word
bindkey '^f' forward-word
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Path and custom tools
export PATH="$HOME/.local/bin:$HOME/node_modules/.bin:$HOME/.cargo/bin:$PATH"
alias grok='$HOME/node_modules/.bin/grok'

# Bun configuration
export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/.local/bin:$BUN_INSTALL/bin:$PATH"
[ -s "/home/xirtus_void/.bun/_bun" ] && source "/home/xirtus_void/.bun/_bun"

# Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# npm global configuration
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# OpenClaw Completion
source "/home/xirtus_void/.openclaw/completions/openclaw.zsh"
