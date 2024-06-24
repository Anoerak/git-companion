#!/bin/bash

# Remove the ~/opt/git-companion directory

# Check if the ~/opt/git-companion directory exists
if [ -d ~/opt/git-companion ]; then
  echo "The ~/opt/git-companion directory exists."
  echo "Removing the ~/opt/git-companion directory."
  rm -rf ~/opt/git-companion
else
  echo "The ~/opt/git-companion directory does not exist."
fi

echo "The scripts have been uninstalled successfully."

# Remove the aliases from the .bashrc file or .bash_profile

# Check if the .bashrc file exists
if [ -f ~/.bashrc ]; then
  echo "The .bashrc file exists."
  for script in ~/opt/git-companion/*; do
	alias_name=$(grep -Eo "# aliased as [a-zA-Z0-9]+" $script | cut -d' ' -f4)
	if [ -z "$alias_name" ]; then
	  continue
	fi
	if grep -q "$alias_name" ~/.bashrc; then
	  echo "Removing the alias $alias_name from the .bashrc file."
	  sed -i "/alias $alias_name/d" ~/.bashrc
	else
	  echo "The alias $alias_name does not exist in the .bashrc file."
	fi
  done
else
  echo "The .bashrc file does not exist."
fi

# Check if the .bash_profile file exists
if [ -f ~/.bash_profile ]; then
  echo "The .bash_profile file exists."
  for script in ~/opt/git-companion/*; do
	alias_name=$(grep -Eo "# aliased as [a-zA-Z0-9]+" $script | cut -d' ' -f4)
	if [ -z "$alias_name" ]; then
	  continue
	fi
	if grep -q "$alias_name" ~/.bash_profile; then
	  echo "Removing the alias $alias_name from the .bash_profile file."
	  sed -i "/alias $alias_name/d" ~/.bash_profile
	else
	  echo "The alias $alias_name does not exist in the .bash_profile file."
	fi
  done
else
  echo "The .bash_profile file does not exist."
fi

echo "The aliases have been removed from the .bashrc and .bash_profile files."
```
