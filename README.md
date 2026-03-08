# 🧔🏻‍♂️ NeckBeard: Scripts for the Minimalist Over-Engineer

Listen up. If you're tired of manually navigating directories like a commoner, you're in the right place. **NeckBeard** is a collection of scripts designed to save you approximately 4-30 seconds of typing 30x a day. For me, hours of bash configuration, to save 100hrs of time later. You're welcome.

---

## 🚀 Quick Start (Before your coffee gets cold)

1. **Clone this into your home directory:**

   ```bash
   git clone https://github.com/Rallanvila/NeckBeard-Scripts.git ~/.neckBeard
   ```

2. **Run the installer:**

   ```bash
   bash ~/.neckBeard/install.sh
   ```

3. **Reload your shell:**
   Run `source ~/.zshrc` or just open a new terminal tab.

---

## 🛑 Requirements

Each script declares its own dependencies and will prompt you to install any that are missing via `pacman` (Arch). Don't say I didn't warn you:

- **fzf** — interactive menus
- **fd** — because `find` is slow and we have things to do
- **tmuxinator** — session management; requires a `.yml` project in `~/.config/tmuxinator/` ([see example](./example-tmuxinatorFolder/))
- **imagemagick** (`magick`) — image optimization
- **Ruby** — ensure `erb` is available in your PATH for tmuxinator

---

## 🛠 Usage

The entry point is the `neckBeard` command. It looks into the `scripts/` folder and executes whatever subcommand you tell it to.

### `tmuxinator`

Stop typing `cd` followed by `tmuxinator start`. This script uses `fzf` to pick a config and a project folder in one go.

```bash
neckBeard tmuxinator
```

- **First Run**: prompts for your `dev` directory and saves it to `settings.env`.
- **Reset**: `neckBeard tmuxinator -r` — wipes the config and prompts again.
- **Workflow**: Select a Tmuxinator `.yml` → Select a subdirectory → Get to work.

### `img-optimize`

Batch-converts images in the current directory to WebP at three sizes (hero, blog, thumb), output to `web_optimized/`.

```bash
neckBeard img-optimize
```

Requires `magick` (imagemagick) and `fd`. If `bat` is installed it previews the script logic before running.

### `nb-worktrees` _(coming soon)_

Git worktree management. Work in progress.

---

## 📂 Project Structure

```
scripts/
├── lib/
│   ├── colors.sh       # Shared color palette (source in every script)
│   └── check-deps.sh   # check_deps() function with install prompt
├── img-optimize.sh
├── nb-worktrees.sh
└── tmuxinator.sh
```

### Shared Libraries

Every script sources `lib/colors.sh` and `lib/check-deps.sh` at the top:

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/check-deps.sh"
```

`check_deps` takes a list of commands, detects which are missing, and offers a `pacman` install prompt. Map command names to package names with an associative array when they differ:

```bash
declare -A DEPS_PACKAGES=([magick]="imagemagick")
check_deps magick fd
```

---

## ✏️ Adding Your Own Scripts

Want to extend the beard?

1. Drop a `.sh` file into `scripts/`.
2. Source the shared libs at the top (see above).
3. Declare your deps: `check_deps your-tool`.
4. Make it executable: `chmod +x scripts/your_script.sh`.
5. Run it via `neckBeard your_script`.

---

_Maintained by someone who spends more time on their terminal theme than their actual job._
