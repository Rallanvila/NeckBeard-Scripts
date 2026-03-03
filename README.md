# 🧔🏻‍♂️ NeckBeard: Scripts for the Minimalist Over-Engineer

Listen up. If you're tired of manually navigating directories like a commoner, you're in the right place. **NeckBeard** is a collection of scripts designed to save you approximately 4-30 seconds of typing 30x a day. For me, hours of bash configuration, to save 100hrs of time later. You're welcome.

---

## 🚀 Quick Start (Before your coffee gets cold)

1. **Clone this into your home directory:**

   ```bash
   git clone https://github.com/rallanvila/neckBeard.git ~/.neckBeard
   ```

2. **Add it to your PATH (So you can feel like a power user):**
   Add this line to your `~/.zshrc` or `~/.bashrc`:

```bash
export PATH="$PATH:$HOME/.neckBeard"
```

1. **Reload your shell:**
   Run `source ~/.zshrc` or just open a new terminal tab.

---

## 🛑 Requirements

If you don't have these installed, the script will exit with an error. Don't say I didn't warn you:

- **fzf**: For the interactive menus.
- **fd**: Because `find` is slow and we have things to do.
- **tmuxinator**: To manage your sessions.
  - tmuxinator `.yaml` project in your `~/.config/tmuxinator/` [See example-tmuxinatorFolder](./example-tmuxinatorFolder/)
- **Ruby**: Specifically, ensure the `erb` gem is available (

## 🛠 Usage

The entry point is the `neckBeard` command. It looks into the `scripts/` folder and executes whatever subcommand you tell it to.

### The Flagship: `fzfDirectories`

Stop typing `cd` followed by `tmuxinator start`. This script uses `fzf` to pick a config and a project folder in one go.

```bash
neckBeard fzfDirectories

```

- **First Run**: It’ll ask for your `dev` directory (e.g., `~/dev/alta`).
- **Persistent Settings**: It saves your path to `~/dev/neckBeardScripts/settings.env` so it doesn't bother you again.
- **The Workflow**: Select a Tmuxinator `.yml` config → Select the project folder subdirectory → Get to work.
- **Reset**: Messed up your path? Run `neckBeard fzfDirectories -r` to wipe the config and start over.

---

## 📂 Adding Your Own Scripts

Want to extend the beard?

1. Drop a `.sh` file into the `scripts/` directory.
2. Make it executable: `chmod +x scripts/your_script.sh`.
3. Run it via `neckBeard your_script`.

---

_Maintained by someone who spends more time on their terminal theme than their actual job._
