# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="~/.oh-my-zsh"
export DEFAULT_USER='davidzisowsky'
export EDITOR='nvim'

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(fzf zsh-interactive-cd safe-paste zsh-syntax-highlighting colorize zsh-completions zsh-autosuggestions terraform aws kubectl helm ripgrep git-auto-fetch z git extract yarn docker docker-compose)
# vi-mode
# plugins=(git extract terraform kubectl nvm node yarn npm vscode docker docker-compose)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="vim ~/.zshrc && source ~/.zshrc"
alias balena-engine=docker
alias be=docker
alias resetToRemote="git reset --hard @{u} && git pull"

export AWS_DEFAULT_REGION="eu-central-1"

function tier_production() {
  saml2aws login -a tier-production --force --skip-prompt --mfa=Auto
  eval $(saml2aws script --idp-account="tier-production")
  aws eks update-kubeconfig --name main-cluster-productions
  kubectx arn:aws:eks:eu-central-1:373437620866:cluster/main-cluster-production
  ~/myscripts/codeartifact.sh 
  aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 373437620866.dkr.ecr.eu-central-1.amazonaws.com
  scp ~/.npmrc linux:~
}

function tier_iot_production() {
  saml2aws login -a tier-iot-production --force --skip-prompt --mfa=Auto
  eval $(saml2aws script --idp-account="tier-iot-production")
  kubectx arn:aws:eks:eu-central-1:373437620866:cluster/main-cluster-production
  ~/myscripts/codeartifact.sh 
}

function tier_plattform_production() {
  saml2aws login -a tier-plattform-production --force --skip-prompt --mfa=Auto
  eval $(saml2aws script --idp-account="tier-plattform-production")
  aws eks update-kubeconfig --name platform
  kubectx arn:aws:eks:eu-central-1:373437620866:cluster/platform
}

function tier_plattform_staging() {
  saml2aws login -a tier-plattform-staging --force --skip-prompt --mfa=Auto
  eval $(saml2aws script --idp-account="tier-plattform-staging")
  aws eks update-kubeconfig --name platform
  kubectx arn:aws:eks:eu-central-1:075108987694:cluster/platform
}

function tier_staging() {
  saml2aws login -a tier-stage --force --skip-prompt 
  eval $(saml2aws script --idp-account="tier-stage")
  kubectx arn:aws:eks:eu-central-1:075108987694:cluster/main-cluster-staging
}

function tier_sandbox() {
  saml2aws login -a tier-sandbox --force --skip-prompt 
  eval $(saml2aws script --idp-account="tier-sandbox")
  kubectx arn:aws:eks:eu-central-1:199745669981:cluster/main-cluster-sandbox
}

# # Created by `pipx` on 2021-10-06 17:12:52
# export PATH="$PATH:/Users/davidzisowsky/.local/bin"

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias vim=nvim
alias vi=nvim
export DOCKERHOST=zubr
export JUMP_HOST=zubr
# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
