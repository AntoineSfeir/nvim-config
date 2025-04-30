# 🧠 Neovim Config

This repository contains my personal Neovim configuration, optimized for development on both **Windows** and **Unix-based systems** (Linux/macOS). The configs are separated into two folders for portability and system-specific setup:

- `windows/` – Configuration tailored for Windows setups
- `unix/` – Configuration tailored for Linux/macOS

---

## 📁 Directory Structure

```
nvim-config-main/
├── unix/
│   └── nvim/
│       ├── init.lua
│       ├── lua/
│       └── lazy-lock.json
├── windows/
│   └── nvim/
│       ├── init.lua
│       ├── lua/
│       └── lazy-lock.json
└── README.md
```

---

## ⚙️ Requirements

To get the configuration running correctly, install the following:

### ✅ Required Software
- [Neovim v0.9+](https://neovim.io)
- [Git](https://git-scm.com)
- A Nerd Font (e.g., [FiraCode Nerd Font](https://www.nerdfonts.com))
- `ripgrep` (for Telescope fuzzy finding)
- `fd` (faster file search)
- `node`, `npm`, and `python3` (for LSP, Treesitter, etc.)
- `cargo` (for some Treesitter parsers or formatters)

### 🔌 Language Server Dependencies

Install LSP servers manually or with [Mason](https://github.com/williamboman/mason.nvim):

- `lua_ls`
- `tsserver`
- `intelephense`
- `eslint`
- `omnisharp` (C# support)
    - On **Windows**, configure the path:  
      `C:\\Users\\yourname\\AppData\\Local\\omnisharp-win-x64\\OmniSharp.exe`
    - On **Unix**, it should be installed to:  
      `/home/yourname/.local/bin/omnisharp-roslyn/OmniSharp`

---

## 🌟 Features

- 🔌 Built-in **LSP support** for multiple languages
- 🧠 **Autocompletion** with `nvim-cmp`
- 🔍 **Fuzzy finding** via `Telescope`
- 🎨 **Treesitter** for syntax highlighting & code navigation
- 🧩 Plugin management with **Lazy.nvim**
- 🖼️ Floating windows with rounded borders and diagnostics
- 📁 Project-aware configuration with custom keybindings

---

## 🚀 Getting Started

Clone this repo and symlink the appropriate config to your Neovim config directory:

### Unix:
```bash
ln -s /path/to/nvim-config-main/unix/nvim ~/.config/nvim
```

### Windows (PowerShell):
```powershell
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "C:\path\to\nvim-config-main\windows\nvim"
```

---

## 🔑 Key Bindings (Partial List)

| Shortcut | Action                          |
|----------|---------------------------------|
| `gd`     | Go to definition                |
| `gr`     | Show references                 |
| `K`      | Hover documentation             |
| `<F2>`   | Rename symbol                   |
| `<F3>`   | Format buffer                   |
| `<F4>`   | Code actions                    |
| `<leader>ff` | Fuzzy find files (Telescope) |
| `<leader>fg` | Fuzzy grep                  |

---

## 📌 Notes

- Make sure your terminal supports true colors and uses a Nerd Font.
- Use `:Mason` inside Neovim to manage and install language servers.
- Omnisharp must be installed and manually referenced in the config.

---

## 📫 Contributing

Feel free to fork and tweak it to your liking. Pull requests are welcome if you want to improve something or fix a bug!

---

## 🧑 Author

Maintained by [Antoine Sfeir](https://github.com/AntoineSfeir).
