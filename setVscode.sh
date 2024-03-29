#!/bin/bash
yad --info --image=/usr/share/icons/language-selector.png --text "Installazione estensioni per visual studio code"  --button=gtk-ok:1 --title="Visual studio setup" --fixed --borders=30 --escape-ok --center

code --install-extension ms-vscode.cpptools
code --install-extension ms-python.python
code --install-extension janisdd.vscode-edit-csv
code --install-extension mhutchie.git-graph
code --install-extension ms-ceintl.vscode-language-pack-it
code --install-extension mechatroner.rainbow-csv
code --install-extension mongodb.mongodb-vscode
code --install-extension redhat-developer.java
code --install-extension redhat.vscode-yaml
code --install-extension redhat.vscode-xml
code --install-extension ms-vscode.cpptools-extension-pack
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension ms-edgedevtools.vscode-edge-devtools
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension foxundermoon.shell-format
code --install-extension lmcarreiro.vscode-smart-column-indenter