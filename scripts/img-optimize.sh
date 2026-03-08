#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/colors.sh
source "$SCRIPT_DIR/lib/colors.sh"
# shellcheck source=lib/check-deps.sh
source "$SCRIPT_DIR/lib/check-deps.sh"

# --- DEPENDENCY CHECK ---
declare -A DEPS_PACKAGES=([magick]="imagemagick" [fd]="fd")
check_deps magick fd

# --- PREVIEW (Optional Syntax Highlighting) ---
if command -v bat &> /dev/null; then
    bat --language=bash "$0"
    echo -e "${CYAN}--- Review the logic above before proceeding ---${NC}"
    read -p "Press Enter to start optimization (or Ctrl+C to abort)..." -r
fi

# --- OPTIMIZATION LOGIC ---
# Create output directories in the current working directory
mkdir -p web_optimized/{heros,blogs,thumbs}

# Use fd to find images (NeckBeard style)
# This handles spaces in filenames safely
mapfile -t images < <(fd -t f -e jpg -e jpeg -e png)

if [ ${#images[@]} -eq 0 ]; then
    echo -e "${YELLOW}No images found in the current directory.${NC}"
    exit 0
fi

echo -e "${BLUE}Optimizing ${#images[@]} images...${NC}"

for f in "${images[@]}"; do
    # Slice extension using your preferred method
    name="${f%.*}"
    echo -e "${PURPLE}Processing:${NC} $f"

    # HERO: 1920px wide, < 500KB
    magick "$f" -resize 1920x -define webp:extent=500kb "web_optimized/heros/${name}_hero.webp"

    # BLOG: 1200px wide, < 200KB
    magick "$f" -resize 1200x -define webp:extent=200kb "web_optimized/blogs/${name}_blog.webp"

    # THUMB: 400px wide, < 50KB
    magick "$f" -resize 400x -define webp:extent=50kb "web_optimized/thumbs/${name}_thumb.webp"
done

echo -e "${GREEN}Success! Optimized images are in 'web_optimized/'${NC}"
