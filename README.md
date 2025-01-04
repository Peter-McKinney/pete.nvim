# pete.nvim

Custom neovim configuration based heavily on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

## Installation

### Install Neovim

['stable'](https://github.com/neovim/neovim/releases/tag/stable) and latest

I frequently do the following to install neovim on linux:

```bash
# Install neovim nightly
curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -o /tmp/nvim-nightly;
chmod +x /tmp/nvim-nightly;
sudo mv /tmp/nvim-nightly /usr/local/bin;

# Install neovim stable
curl -L https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -o /tmp/nvim-stable;
chmod +x /tmp/nvim-stable;
sudo mv /tmp/nvim-stable /usr/local/bin;

```

### Install External Dependencies

External Requirements:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on the platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
  - [getnf](https://github.com/getnf/getnf) is a simple method to install nerdfonts from the terminal

### Install

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%localappdata%\nvim\` |

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/Peter-McKinney/pete.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

### Post Installation

Start Neovim

```sh
nvim
```

Lazy will install all the plugins you have. Use `:Lazy` to view
current plugin status. Hit `q` to close the window.

#### Linux Install
<details><summary>Ubuntu Install Steps</summary>

```
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>
