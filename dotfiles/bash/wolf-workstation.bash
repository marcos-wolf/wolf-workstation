# Wolf Workstation shell configuration

# User-local environment
if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
fi

# mise
if [ -x "$HOME/.local/bin/mise" ]; then
    eval "$("$HOME/.local/bin/mise" activate bash)"
fi
