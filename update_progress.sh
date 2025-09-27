#!/bin/bash

# Map status to emojis
declare -A STATUS_EMOJI=( ["Not Started"]="⬜" ["In Progress"]="🔄" ["Completed"]="✅" )

# Read progress.txt and build the progress section
PROGRESS_SECTION="# Progress Tracker\nTrack your weekly progress with emojis:\n- ⬜ Not Started\n- 🔄 In Progress\n- ✅ Completed\n\n"

while IFS= read -r line; do
  # Skip empty lines and comments
  [[ -z "$line" || "$line" =~ ^# ]] && continue
  # Extract week and status
  week="${line%:*}"
  status="${line#*: }"
  emoji="${STATUS_EMOJI[$status]}"
  PROGRESS_SECTION+="- $week : $emoji\n"
done < progress.txt

# 2️⃣ Replace the progress section in README.md
# Backup current README
cp README.md README_backup.md

# Keep everything after "## Frontend Development" section
TAIL_CONTENT=$(sed -n '/^## Frontend Development/,$p' README_backup.md)

# Combine new progress section with rest of README
echo -e "$PROGRESS_SECTION\n$TAIL_CONTENT" > README.md

echo "✅ README.md updated based on progress.txt"
