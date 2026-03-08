#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/colors.sh
source "$SCRIPT_DIR/lib/colors.sh"
# shellcheck source=lib/check-deps.sh
source "$SCRIPT_DIR/lib/check-deps.sh"

# --- HELP ---
show_help() {
    cat << EOF
${PURPLE}Usage:${NC} neckbeard img-optimize [-h]

Batch-convert images in a directory to WebP at three sizes.

${YELLOW}Options:${NC}
  -h, --help    Show this help message and exit.

${CYAN}Output sizes:${NC}
  hero   1920px wide, < 500KB  →  web_optimized/heros/
  blog   1200px wide, < 200KB  →  web_optimized/blogs/
  thumb   400px wide, <  50KB  →  web_optimized/thumbs/

${CYAN}Workflow:${NC}
  You will be prompted for the target directory.
  Enter a full path, ~/relative/path, or ${PURPLE}.${CYAN} for the current directory.

${YELLOW}Dependencies:${NC} magick (imagemagick), fd
EOF
}

case "$1" in
    -h|--help) show_help; exit 0 ;;
esac

# --- DEPENDENCY CHECK ---
declare -A DEPS_PACKAGES=([magick]="imagemagick" [fd]="fd")
check_deps magick fd

# --- PATH SELECTION ---
echo -e "${YELLOW}Enter the path to the directory containing images.${NC}"
echo -ne "${CYAN}Path (or ${PURPLE}.${CYAN} for current directory): ${NC}"
read -r INPUT_PATH

if [ "$INPUT_PATH" = "." ] || [ -z "$INPUT_PATH" ]; then
    TARGET_DIR="$(pwd)"
else
    # Expand tilde
    INPUT_PATH="${INPUT_PATH/#\~/$HOME}"
    TARGET_DIR="$INPUT_PATH"
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}Error: '$TARGET_DIR' is not a valid directory.${NC}"
    exit 1
fi

echo -e "${BLUE}Running in: ${PURPLE}$TARGET_DIR${NC}"
cd "$TARGET_DIR" || exit 1

# --- PREVIEW (Optional Syntax Highlighting) ---
if command -v bat &> /dev/null; then
    bat --language=bash "$0"
    echo -e "${CYAN}--- Review the logic above before proceeding ---${NC}"
    read -p "Press Enter to start optimization (or Ctrl+C to abort)..." -r
fi

# --- OPTIMIZATION LOGIC ---
mkdir -p web_optimized/{heros,blogs,thumbs}

# Use fd to find images (NeckBeard style)
# This handles spaces in filenames safely
mapfile -t images < <(fd -t f -e jpg -e jpeg -e png)

if [ ${#images[@]} -eq 0 ]; then
    echo -e "${YELLOW}No images found in '$TARGET_DIR'.${NC}"
    exit 0
fi

echo -e "${BLUE}Optimizing ${#images[@]} images...${NC}"

for f in "${images[@]}"; do
    name="${f%.*}"
    echo -e "${PURPLE}Processing:${NC} $f"

    # HERO: 1920px wide, < 500KB
    magick "$f" -resize 1920x -define webp:extent=500kb "web_optimized/heros/${name}_hero.webp"

    # BLOG: 1200px wide, < 200KB
    magick "$f" -resize 1200x -define webp:extent=200kb "web_optimized/blogs/${name}_blog.webp"

    # THUMB: 400px wide, < 50KB
    magick "$f" -resize 400x -define webp:extent=50kb "web_optimized/thumbs/${name}_thumb.webp"
done

echo -e "${GREEN}Success! Optimized images are in '$TARGET_DIR/web_optimized/'${NC}"
