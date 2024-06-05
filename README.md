# justed.nvim

## Introduction

justed.nvim serves a starting point for Neovim users who do not need IDE features but still want all the goodies of Neovim customizations.

It is actually just an init.lua nvim configuration file, at least it starts off as just that. The file is small, with comments on what each setting does.

As of the date of creating justed.nvim, the init.lua is my actual nvim configuration. I use Neovim daily in my work and do not code much.

If this is good enough for my salary-paying job, I hope this is good enough for anyone wishing to try out and learn Neovim.

justed.nvim is heavily inspired by [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## Installation

1. Create an `init.lua` file under Neovim's configuration path, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%userprofile%\AppData\Local\nvim\` |
| Windows (powershell)| `$env:USERPROFILE\AppData\Local\nvim\` |

2. Copy the content of `init.lua` in this repo. Then, restart Neovim or, save and resource the file in current Neovim session:

```
write | source
```

