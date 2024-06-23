#!/bin/bash

# chmod +x gitignore.sh
# chmod -x gitignore.sh
# ./gitignore.sh

gitignore_content=(
    "# .gitignore"

    "# Folders"
    "# =================================================="
    
    "# Node modules directory"
    "node_modules/"
    
    "# Python virtual environment directories"
    "venv/"
    ".env/"
    
    "# Logs directory"
    "logs/"
    "log/"
    
    "# OS-generated files"
    ".DS_Store"
    "Thumbs.db"
    
    "# Compiled source files"
    "build/"
    "dist/"
    
    "# Dependency directories"
    "bower_components/"
    "jspm_packages/"
    
    "# Files"
    "# =================================================="
    
    "# Environment variable files"
    ".env"
    ".env.local"
    ".env.*.local"
    
    "# Logs files"
    "npm-debug.log*"
    "yarn-debug.log*"
    "yarn-error.log*"
    
    "# Editor and IDE files"
    ".vscode/"
    ".idea/"
    "*.suo"
    "*.ntvs*"
    "*.njsproj"
    "*.sln"
    
    "# System files"
    ".DS_Store"
    "Thumbs.db"
    
    "# Build files"
    "*.out"
    "*.app"
    "*.exe"
    "*.dll"
    
    "# Node.js specific"
    "# =================================================="
    "# Dependencies"
    "node_modules/"
    "npm-debug.log*"
    "yarn-debug.log*"
    "yarn-error.log*"
    
    "# Optional npm cache directory"
    ".npm"
    
    "# Grunt intermediate storage (https://gruntjs.com/creating-plugins#storing-task-files)"
    ".grunt"
    
    "# Bower dependency directory (https://bower.io/)"
    "bower_components/"
    
    "# Typescript v1 declaration files"
    "typings/"
    
    "# Optional eslint cache"
    ".eslintcache"
    
    "# Optional REPL history"
    ".node_repl_history"
    
    "# Python specific"
    "# =================================================="
    "# Byte-compiled / optimized / DLL files"
    "__pycache__/"
    "*.py[cod]"
    "*$py.class"
    
    "# C extensions"
    "*.so"
    
    "# Distribution / packaging"
    ".Python"
    "build/"
    "develop-eggs/"
    "dist/"
    "downloads/"
    "eggs/"
    ".eggs/"
    "lib/"
    "lib64/"
    "parts/"
    "sdist/"
    "var/"
    "*.egg-info/"
    ".installed.cfg"
    "*.egg"
    "MANIFEST"
    
    "# PyInstaller"
    "# Usually these files are written by a python script from a template"
    "# before PyInstaller builds the exe, so as to inject date/other infos into it."
    "*.manifest"
    "*.spec"
    
    "# Installer logs"
    "pip-log.txt"
    "pip-delete-this-directory.txt"
    
    "# Unit test / coverage reports"
    "htmlcov/"
    ".tox/"
    ".nox/"
    ".coverage"
    ".cache"
    "nosetests.xml"
    "coverage.xml"
    "*.cover"
    "*.py,cover"
    ".hypothesis/"
    
    "# Translations"
    "*.mo"
    "*.pot"
    
    "# Django stuff:"
    "*.log"
    "local_settings.py"
    "db.sqlite3"
    "db.sqlite3-journal"
    
    "# Flask stuff:"
    "instance/"
    ".webassets-cache"
    
    "# Scrapy stuff:"
    ".scrapy"
    
    "# Sphinx documentation"
    "docs/_build/"
    
    "# PyBuilder"
    "target/"
    
    "# Jupyter Notebook"
    ".ipynb_checkpoints"
    
    "# IPython"
    "profile_default/"
    "ipython_config.py"
    
    "# Environments"
    ".env"
    ".venv"
    "env/"
    "venv/"
    "ENV/"
    "env.bak/"
    "venv.bak/"
    
    "# Spyder project settings"
    ".spyderproject"
    ".spyderworkspace"
    
    "# Rope project settings"
    ".ropeproject"
    
    "# General settings"
    "# =================================================="
    
    "# Visual Studio Code"
    ".vscode/"
    
    "# WebStorm"
    ".idea/"
    
    "# MacOS system files"
    ".DS_Store"
    
    "# Windows system files"
    "Thumbs.db"
)

create_gitignore() {
	printf "%s\n" "${gitignore_content[@]}" > .gitignore
}

create_gitignore