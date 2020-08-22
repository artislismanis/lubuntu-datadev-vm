#!/bin/bash -e

#echo "==> Set git user and email details..."
#git config --global user.name "Firstname Lastname"
#git config --global user.email "firstname.lastname@example.com"

#echo "==> Generate SSH Keys for use with remote VCS..."
#ssh-keygen -t rsa -N "" -f ~/.ssh/vcs.key -C ""
#chmod 600 ~/.ssh/vcs.key
#chmod 600 ~/.ssh/vcs.key.pub
#cat <<EOF > ~/.ssh/config
#Host bitbucket.org
#	Hostname bitbucket.org
#	User git
#	IdentityFile ~/.ssh/vcs.key
#	IdentitiesOnly yes
#
#Host github.com
#	Hostname github.com
#	User git
#	IdentityFile ~/.ssh/vcs.key
#	IdentitiesOnly yes
# 
#EOF

#chmod 600 ~/.ssh/config

#echo "==> Install VSCode Extensions..."
#code --install-extension paiqo.databricks-vscode
#code --install-extension ms-python.python
#code --install-extension streetsidesoftware.code-spell-checker
#code --install-extension bierner.github-markdown-preview
#code --install-extension davidanson.vscode-markdownlint
#code --install-extension ms-azuretools.vscode-azurestorage
#code --install-extension ms-azuretools.vscode-azurefunctions
#code --install-extension ms-vscode.azure-account
#code --install-extension ms-vscode.azurecli
#code --install-extension AndrsDC.base16-themes

#echo "==> Personalize VS Code settings"
#cat <<EOF > ~/.config/Code/User/settings.json
#{
#	"workbench.colorTheme": "Base16 Dark Ocean",
#}
#
#EOF
