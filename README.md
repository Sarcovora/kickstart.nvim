# My custom neovim config, forked from kickstart.nvim

## Branches

| Branch | Requires | nvim-treesitter |
|---|---|---|
| `master` | **Neovim 0.12+** | `main` branch (the rewrite) |
| `nvim-0.11` | Neovim 0.11.x | `master` branch (frozen upstream) |

`master` is the one that tracks current versions. On a machine still stuck on
Neovim 0.11, check out `nvim-0.11` instead — nvim-treesitter's `main` branch
dropped 0.11 support, and its `master` branch is frozen but kept working for
exactly that case.

## Cloning this config

```sh
git clone https://github.com/Sarcovora/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# only if the machine is still on Neovim 0.11
cd "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim && git checkout nvim-0.11
```

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
> **NOTE:** `master` needs Neovim **0.12+**; the `nvim-0.11` branch needs 0.11.x.
> The release assets were renamed upstream — it's `nvim-linux-x86_64.appimage`
> now, not `nvim.appimage` (use `-arm64` on ARM machines).
- `curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage`
- `chmod u+x nvim-linux-x86_64.appimage`
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

**Required**

- Basic utils: `git`, `make`, `unzip`, a C compiler (`gcc`/`clang`)
- [`ripgrep`](https://github.com/BurntSushi/ripgrep#installation) — telescope's grep backend
- Clipboard tool (xclip/xsel/win32yank or other depending on platform)
- On `master` only: [`tree-sitter-cli`](https://github.com/tree-sitter/tree-sitter)
  **>= 0.26.1**, installed via a package manager rather than npm
  (`brew install tree-sitter-cli`). nvim-treesitter's `main` branch builds
  parsers with it. Not needed on `nvim-0.11`.

**Optional but assumed by parts of the config**

- A [Nerd Font](https://www.nerdfonts.com/) — icons throughout; `vim.g.have_nerd_font` in `init.lua` is set to `true`
- [`fd`](https://github.com/sharkdp/fd) — `telescope.lua` prefers it for file listing and falls back to `rg --files`
- [`lazygit`](https://github.com/jesseduffield/lazygit) — required by `lazygit.lua` (`<leader>gg`)
- [`yazi`](https://github.com/sxyazi/yazi) — required by `yazi.lua`
- `node`/`npm` — Mason installs the TypeScript, Angular and markdownlint tooling through it
- `python3` — pylsp
- A LaTeX toolchain + a PDF viewer — `vimtex.lua`
- The [`claude`](https://claude.ai/code) CLI — `claude-code.lua` (`<leader>cc`)

Language servers, formatters and linters themselves are installed by
[Mason](https://github.com/mason-org/mason.nvim) on first launch (`:Mason`), so
they don't need to be on the system beforehand.

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

After installing all the dependencies continue with [Cloning this config](#cloning-this-config).

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
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
```

> The distro packages in the `apt`/`dnf`/`pacman` recipes above are usually far
> behind 0.12 — prefer this tarball, or the AppImage, on `master`.
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

## Plugins

Every plugin lives in its own spec file under `lua/plugins/`, wired up in the
`require('lazy').setup{}` call in `init.lua`. A few specs are checked in but
commented out there — they're marked **off** below and load nothing until you
uncomment the corresponding line.

### Editing core

| Spec | Plugin | Purpose |
|---|---|---|
| `treesitter.lua` | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Parsers + highlighting/indent. `main` branch on `master`, `master` branch on `nvim-0.11` |
| `lspconfig.lua` | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason](https://github.com/mason-org/mason.nvim) | LSP setup, server install, diagnostics config |
| `autocompletion.lua` | [blink.cmp](https://github.com/saghen/blink.cmp) | Completion, with [LuaSnip](https://github.com/L3MON4D3/LuaSnip) snippets |
| `autoformat.lua` | [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting (`<leader>ff`), whitespace clean (`<leader>fl`) |
| `lint.lua` | [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Linting; only runs linters whose binary is present |
| `debug.lua` | [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Debugger + dap-ui |
| `lazydev.lua` | [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Lua LSP that understands the Neovim API |
| `mini-nvim.lua` | [mini.nvim](https://github.com/echasnovski/mini.nvim) | Surround, extended text objects |
| `autopairs.lua` | [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Bracket/quote pairing |
| `guess-indent.lua` | [guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim) | Detect tabstop/shiftwidth per file |
| `treesj.lua` | [treesj](https://github.com/Wansmer/treesj) | Split/join blocks |
| `todo-comments.lua` | [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight TODO/NOTE/FIX |
| `undotree.lua` | [undotree](https://github.com/mbbill/undotree) | Undo history browser |
| `highlight-undo.lua` | [highlight-undo.nvim](https://github.com/tzachar/highlight-undo.nvim) | Flash what undo/redo changed |
| `neotest.lua` | [neotest](https://github.com/nvim-neotest/neotest) | Test runner (`<leader>n…`) — **off** |

### Navigation

| Spec | Plugin | Purpose |
|---|---|---|
| `telescope.lua` | [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder; `<leader>sf` files, `<leader>sg` repo-root grep, capitals include ignored files |
| `neo-tree.lua` | [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | Sidebar file explorer |
| `oil.lua` | [oil.nvim](https://github.com/stevearc/oil.nvim) | Edit the filesystem as a buffer |
| `yazi.lua` | [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) | Yazi file manager (needs the `yazi` binary) |
| `harpoon.lua` | [harpoon](https://github.com/ThePrimeagen/harpoon) | Pinned-file quick switching |
| `buffer-manager.lua` | [buffer_manager.nvim](https://github.com/j-morano/buffer_manager.nvim) | Buffer list as an editable menu |
| `outline.lua` | [outline.nvim](https://github.com/hedyhli/outline.nvim) | Symbol outline pane |
| `leap.lua` | [leap.nvim](https://github.com/ggandor/leap.nvim) | Two-character motion jumps |
| `autosession.lua` | [auto-session](https://github.com/rmagatti/auto-session) | Restore sessions per directory |
| `whichkey.lua` | [which-key.nvim](https://github.com/folke/which-key.nvim) | Pending-keybind popup + `<leader>` group labels |

### Appearance

| Spec | Plugin | Purpose |
|---|---|---|
| `colorscheme.lua` | [rose-pine](https://github.com/rose-pine/neovim) | Colorscheme |
| `heirline.lua` | [heirline.nvim](https://github.com/rebelot/heirline.nvim) | Statusline |
| `incline.lua` | [incline.nvim](https://github.com/b0o/incline.nvim) | Floating per-window filename |
| `dropbar.lua` | [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim) | Breadcrumb winbar |
| `hlchunk.lua` | [hlchunk.nvim](https://github.com/shellRaining/hlchunk.nvim) | Highlight the enclosing code chunk |
| `snacks.lua` | [snacks.nvim](https://github.com/folke/snacks.nvim) | Grab bag; only bigfile/quickfile/scope enabled |
| `inline-diagnostic.lua` | [tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim) | Prettier inline diagnostics |
| `colorizer.lua` | [nvim-colorizer.lua](https://github.com/catgoose/nvim-colorizer.lua) | Render colour codes in place (catgoose's maintained fork) |
| `treesitter_context.lua` | [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Sticky context header — **off** |
| `indent_line.lua` | [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides — **off**, superseded by hlchunk |

### Git, writing, AI

| Spec | Plugin | Purpose |
|---|---|---|
| `gitsigns.lua` | [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Gutter signs, hunk keymaps (`<leader>h…`) |
| `lazygit.lua` | [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | Lazygit in a float (needs the `lazygit` binary) |
| `render_markdown.lua` | [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | In-buffer markdown rendering |
| `vimtex.lua` | [vimtex](https://github.com/lervag/vimtex) | LaTeX (`<leader>l…`) |
| `claude-code.lua` | [claude-code.nvim](https://github.com/greggh/claude-code.nvim) | Claude Code in a split (`<leader>cc`) |
| `markdown_preview.lua` | [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | Browser preview — **off** |
| `copilot.lua` | [copilot.vim](https://github.com/github/copilot.vim) | GitHub Copilot — **off**, replaced by claude-code |

Two plugins are declared inline in `init.lua` rather than getting their own
spec file: [`csharpls-extended-lsp.nvim`](https://github.com/Decodetalkers/csharpls-extended-lsp.nvim)
and [`nvim-numbertoggle`](https://github.com/sitiom/nvim-numbertoggle).

`lua/plugins/plugin-data/` holds the CSS themes `markdown_preview.lua` points at.

---
## Folder Structure
```
.
├── .github
│   ├── ISSUE_TEMPLATE
│   │   └── bug_report.md
│   ├── pull_request_template.md
│   └── workflows
│       └── stylua.yml
├── .gitignore
├── .stylua.toml
├── LICENSE.md
├── README.md
├── init.lua
├── lazy-lock.json
└── lua
    ├── health.lua
    └── plugins
        ├── autocompletion.lua
        ├── autoformat.lua
        ├── autopairs.lua
        ├── autosession.lua
        ├── buffer-manager.lua
        ├── claude-code.lua
        ├── colorizer.lua
        ├── colorscheme.lua
        ├── copilot.lua
        ├── debug.lua
        ├── dropbar.lua
        ├── gitsigns.lua
        ├── guess-indent.lua
        ├── harpoon.lua
        ├── heirline.lua
        ├── highlight-undo.lua
        ├── hlchunk.lua
        ├── incline.lua
        ├── indent_line.lua
        ├── inline-diagnostic.lua
        ├── lazydev.lua
        ├── lazygit.lua
        ├── leap.lua
        ├── lint.lua
        ├── lspconfig.lua
        ├── markdown_preview.lua
        ├── mini-nvim.lua
        ├── neo-tree.lua
        ├── neotest.lua
        ├── oil.lua
        ├── outline.lua
        ├── plugin-data
        │   ├── github_md.css
        │   ├── md.css
        │   ├── mdhl.css
        │   ├── screen_md.css
        │   └── splendor_md.css
        ├── render_markdown.lua
        ├── snacks.lua
        ├── telescope.lua
        ├── todo-comments.lua
        ├── treesitter.lua
        ├── treesitter_context.lua
        ├── treesj.lua
        ├── undotree.lua
        ├── vimtex.lua
        ├── whichkey.lua
        └── yazi.lua

7 directories, 57 files
```
