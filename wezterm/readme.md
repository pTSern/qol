# WezTerm Configuration Guide

A modern, high-performance, and modal-based configuration for the [WezTerm](https://wezterm.org/) terminal emulator, inspired by Zellij and tmux modal layouts.

---

## 🚀 Installation

To install WezTerm on your system:

1. **Official Site**: Visit the [WezTerm Installation Guide](https://wezterm.org/installation.html) for detailed binaries and installation steps.
2. **Package Managers**:
   - **Windows**: Run this command in PowerShell:
     ```powershell
     winget install wez.wezterm
     ```
   - **macOS**: Run this command in Terminal:
     ```bash
     brew install --cask wezterm
     ```
   - **Linux**: Install via your distribution's package manager (e.g. `apt install wezterm` on Debian/Ubuntu, `dnf install wezterm` on Fedora, or `pacman -S wezterm` on Arch Linux).

---

## 📂 Configuration Location

For WezTerm to load this configuration, you must place the [.wezterm.lua](file:///.wezterm.lua) file in your user's home directory.

- **Windows**: Place it at `C:\Users\<YourUsername>\.wezterm.lua` (Shell representation: `$HOME\.wezterm.lua` or `~/.wezterm.lua`).
- **macOS / Linux**: Place it at `/Users/<YourUsername>/.wezterm.lua` or `/home/<YourUsername>/.wezterm.lua` (Shell representation: `~/.wezterm.lua` or `$HOME/.wezterm.lua`).

> [!TIP]
> You can quickly copy the file using PowerShell on Windows:
> ```powershell
> Copy-Item -Path ".\.wezterm.lua" -Destination "$HOME\.wezterm.lua"
> ```
> Or using Bash on macOS/Linux:
> ```bash
> cp .wezterm.lua ~/.wezterm.lua
> ```

---

## 🎨 Features & Visual Indicators

This configuration features:
- **Font**: `Hack Nerd Font` (Size 13)
- **Theme**: `Catppuccin Mocha`
- **Transparency**: Sleek window acrylic blur setup (`0.8` opacity) with focus fixes.
- **Window Size**: Auto-positions centered at the top-right of your active monitor on startup.
- **Modal Status Bar**: The bottom-left displays the current active mode. Modes help keep keybindings simple and clash-free.

| Mode Indicator | Background Color | Description |
| :--- | :---: | :--- |
| **NORMAL** | Green | Default typing and navigation mode |
| **LOCKED** | Red | Disables custom binds; passes all keys to current shell/program (e.g. nested terminal) |
| **PANE** | Lavender | Pane creation, naming, zooming, navigation, and deletion |
| **TAB** | Yellow | Tab creation, selection, movement, renaming, and deletion |
| **RESIZE** | Pink | Fine-grained pane size adjustment |
| **MOVE** | Blue | Rotate/rearrange panes visually |
| **SCROLL** | Orange | WezTerm's native search/copy mode |
| **SESSION** | Teal | Workspace and tab overview launchers |
| **TMUX** | Purple | Tmux-like prefix mode for pane & tab management |

---

## ⌨️ Keybindings

This configuration disables all default WezTerm keybindings (`disable_default_key_bindings = true`) and establishes a modal layout.

### 🌐 Global / Normal Mode Keybindings
These shortcuts are available at all times (except when in **LOCKED** mode).

| Keybinding | Action |
| :--- | :--- |
| `Ctrl + g` | Enter **LOCKED** mode (locks bindings so shell/application receives keys) |
| `Ctrl + p` | Enter **PANE** mode |
| `Ctrl + t` | Enter **TAB** mode |
| `Ctrl + n` | Enter **RESIZE** mode |
| `Ctrl + h` | Enter **MOVE** mode |
| `Ctrl + s` | Enter **SCROLL** (Copy) Mode |
| `Ctrl + b` | Enter **TMUX** mode |
| `Ctrl + i` | Enter **SESSION** mode |
| `Ctrl + q` | Quit WezTerm |
| `Alt + h` / `Alt + LeftArrow` | Focus pane to the left |
| `Alt + j` / `Alt + DownArrow` | Focus pane below |
| `Alt + k` / `Alt + UpArrow` | Focus pane above |
| `Alt + l` / `Alt + RightArrow` | Focus pane to the right |
| `Alt + +` | Increase font size |
| `Alt + -` | Decrease font size |
| `Alt + =` | Reset font size |
| `Alt + i` | Move current tab left (relative -1) |
| `Alt + o` | Move current tab right (relative +1) |
| `Alt + Shift + h` | Activate tab to the left |
| `Alt + Shift + l` | Activate tab to the right |
| `Alt + f` | Toggle active pane zoom (maximize / restore) |
| `Alt + n` | Split active pane horizontally and exit key table |

---

### 🔒 LOCKED Mode
Used when you need to pass raw control inputs through to a nested terminal or application.
- **`Ctrl + g`**: Exit locked mode and return to **NORMAL** mode.
- *Any other inputs* are passed straight through.

---

### 🪟 PANE Mode (`Ctrl + p`)
Manage WezTerm layout splits and sub-windows.

| Key | Action |
| :---: | :--- |
| `h` / `LeftArrow` | Focus pane to the left |
| `j` / `DownArrow` | Focus pane below |
| `k` / `UpArrow` | Focus pane above |
| `l` / `RightArrow` | Focus pane to the right |
| `c` | Rename current pane (prompts for title input) |
| `d` | Split pane vertically and exit pane mode |
| `e` / `f` | Toggle active pane zoom (maximize / restore) and exit pane mode |
| `n` / `r` / `s` | Split pane horizontally and exit pane mode |
| `p` | Focus the next pane |
| `x` | Close the current pane (without confirmation) and exit pane mode |
| **`Escape` / `Enter` / `Ctrl + p`** | Exit Pane mode and return to **NORMAL** mode |

---

### 🏷️ TAB Mode (`Ctrl + t`)
Manage and navigate workspaces windows/tabs.

| Key | Action |
| :---: | :--- |
| `h` / `LeftArrow` / `j` / `UpArrow` | Go to the previous tab |
| `l` / `RightArrow` / `k` / `DownArrow` | Go to the next tab |
| `1` - `9` | Go directly to tab 1 - 9 and exit tab mode |
| `Tab` | Switch to last active tab |
| `n` | Create a new tab and exit tab mode |
| `d` | Close the current tab (without confirmation) and exit tab mode |
| `r` | Rename current tab (prompts for title input) and exit tab mode |
| `b` | Move current pane to a new tab and exit tab mode |
| `[` | Move current pane to a new tab, slide tab left, and exit tab mode |
| `]` | Move current pane to a new tab, slide tab right, and exit tab mode |
| **`Escape` / `Enter` / `Ctrl + t`** | Exit Tab mode and return to **NORMAL** mode |

---

### 📐 RESIZE Mode (`Ctrl + n`)
Fine-tune the size of the active pane.

| Key | Action |
| :---: | :--- |
| `h` / `LeftArrow` / `Shift + L` | Adjust size Left by 5 cells |
| `l` / `RightArrow` / `Shift + H` | Adjust size Right by 5 cells |
| `k` / `UpArrow` / `Shift + J` / `+` / `=` | Adjust size Up by 5 cells |
| `j` / `DownArrow` / `Shift + K` / `-` | Adjust size Down by 5 cells |
| **`Escape` / `Enter` / `Ctrl + n`** | Exit Resize mode and return to **NORMAL** mode |

---

### 🔄 MOVE Mode (`Ctrl + h`)
Reorganize and rotate layout panes.

| Key | Action |
| :---: | :--- |
| `h` / `LeftArrow` / `k` / `UpArrow` | Rotate panes layout CounterClockwise |
| `l` / `RightArrow` / `j` / `DownArrow` | Rotate panes layout Clockwise |
| **`Escape` / `Enter` / `Ctrl + h`** | Exit Move mode and return to **NORMAL** mode |

---

### 📡 SESSION Mode (`Ctrl + i`)
Control session behavior and browse setups.

| Key | Action |
| :---: | :--- |
| `w` | Open workspace listing/launcher and exit session mode |
| `s` | Open tab listing/launcher and exit session mode |
| **`Escape` / `Enter` / `Ctrl + i`** | Exit Session mode and return to **NORMAL** mode |

---

### 🚂 TMUX Mode (`Ctrl + b`)
For users accustomed to tmux key bindings.

| Key | Action |
| :---: | :--- |
| `h` / `LeftArrow` | Focus pane to the left and exit tmux mode |
| `j` / `DownArrow` | Focus pane below and exit tmux mode |
| `k` / `UpArrow` | Focus pane above and exit tmux mode |
| `l` / `RightArrow` | Focus pane to the right and exit tmux mode |
| `o` | Focus next pane |
| `n` | Go to the next tab and exit tmux mode |
| `p` | Go to the previous tab and exit tmux mode |
| `Space` | Rotate panes layout Clockwise |
| `"` | Split pane vertically and exit tmux mode |
| `%` | Split pane horizontally and exit tmux mode |
| `,` | Rename current tab (prompts for title input) and exit tmux mode |
| `[` | Enter Copy (Scroll) mode and exit tmux mode |
| `c` | Create a new tab and exit tmux mode |
| `z` | Toggle active pane zoom and exit tmux mode |
| `x` | Close the current pane (without confirmation) and exit tmux mode |
| `d` | Close current tab (without confirmation) and exit tmux mode |
| **`Escape` / `Enter` / `Ctrl + b`** | Exit Tmux mode and return to **NORMAL** mode |
