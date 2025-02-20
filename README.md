# My custom neovim config, forked from kickstart.nvim

## Cloning this config

```sh
git clone https://github.com/Sarcovora/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> For Windows </summary>

If you're using `cmd.exe`:

```
git clone https://github.com/Sarcovora/kickstart.nvim.git "%localappdata%\nvim"
```

If you're using `powershell.exe`

```
git clone https://github.com/Sarcovora/kickstart.nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

## Installations

### Installing Neovim without SUDO:
> **NOTE:** I believe this requires >= 0.9.6 nvim
- `curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage`
- `chmod u+x nvim.appimage`
- `echo 'export PATH="$HOME/{WHATEVER PATH HERE}:$PATH"' >> ~/.zshrc && source ~/.zshrc`
	- one that I use is: `/home/ekuo/.local/bin`

### Installing ripgrep and fzf without sudo (used in telescope)

**Ripgrep**

```bash
curl -LO 'https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz'
tar xf ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz
cd ripgrep-13.0.0-x86_64-unknown-linux-musl
# You can then put the `rg` binary anywhere. Convention might be `$HOME/bin`, but usually any directory that's in your `PATH` is suitable.
# can move to ~/.local/bin/ with the following: mv ./rg ~/.local/bin
```

**Fzf**

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Install External Dependencies

<details><summary>External Requirements</summary>

- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`) [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
- Language Setup:
  - If you want to write Typescript, you need `npm`
  - If you want to write Golang, you will need `go`
  - etc.

> **NOTE**
> [Backup](#FAQ) your previous configuration (if any exists)

  </details>

<details><summary>Where's the neovim config?</summary>

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%localappdata%\nvim\` |
| Windows (powershell)| `$env:LOCALAPPDATA\nvim\` |

</details>


### Install Recipes

Below you can find OS specific install instructions for Neovim and dependencies.

After installing all the dependencies continue with the [Install Kickstart](#Install-Kickstart) step.

<details><summary>Windows Installation</summary>

<details><summary>Windows with Microsoft C++ Build Tools and CMake</summary>

Installation may require installing build tools and updating the run command for `telescope-fzf-native`

See `telescope-fzf-native` documentation for [more details](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation)

This requires:

- Install CMake and the Microsoft C++ Build Tools on Windows

```lua
{'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
```
</details>

<details><summary>Windows with gcc/make using chocolatey</summary>

Alternatively, one can install gcc and make which don't require changing the config,
the easiest way is to use choco:

1. install [chocolatey](https://chocolatey.org/install)
either follow the instructions on the page or use winget,
run in cmd as **admin**:
```
winget install --accept-source-agreements chocolatey.chocolatey
```

2. install all requirements using choco, exit previous cmd and
open a new one so that choco path is set, and run in cmd as **admin**:
```
choco install -y neovim git ripgrep wget fd unzip gzip mingw make
```
</details>
<details><summary>WSL (Windows Subsystem for Linux)</summary>

```
wsl --install
wsl
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>
</details>

<details><summary>Linux Install</summary>

<details><summary>Ubuntu Install Steps</summary>

```
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>
<details><summary>Debian Install Steps</summary>

```
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim-linux64
sudo mkdir -p /opt/nvim-linux64
sudo chmod a+rX /opt/nvim-linux64
sudo tar -C /opt -xzf nvim-linux64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/
```
</details>
<details><summary>Fedora Install Steps</summary>

```
sudo dnf install -y gcc make git ripgrep fd-find unzip neovim
```
</details>

<details><summary>Arch Install Steps</summary>

```
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim
```
</details>
</details>

---
## Folder Structure
```
~/.config/nvim
├── LICENSE.md
├── README.md
├── init.lua
├── lazy-lock.json
└── lua
    ├── health.lua
    └── plugins
        ├── autopairs.lua
        ├── autosession.lua
        ├── colorizer.lua
        ├── copilot.lua
        ├── dashboard.lua
        ├── debug.lua
        ├── eyeliner.lua
        ├── gitsigns.lua
        ├── harpoon.lua
        ├── indent_line.lua
        ├── lazygit.lua
        ├── lint.lua
        ├── markdown_preview.lua
        ├── neo-tree.lua
        ├── neoscroll.lua
        ├── oil.lua
        ├── outline.lua
        ├── plugin-data
        │   ├── github_md.css
        │   ├── md.css
        │   ├── mdhl.css
        │   ├── screen_md.css
        │   └── splendor_md.css
        ├── render_markdown.lua
        ├── treesitter_context.lua
        ├── treesj.lua
        ├── vimtex.lua
        └── yazi.lua

4 directories, 32 files
```
