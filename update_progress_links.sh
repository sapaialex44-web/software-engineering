#!/bin/bash

# Map status to emojis
declare -A STATUS_EMOJI=( ["Not Started"]="⬜" ["In Progress"]="🔄" ["Completed"]="✅" )

# 1️⃣ Read progress.txt and store in associative array
declare -A WEEK_STATUS
while IFS= read -r line; do
  [[ -z "$line" || "$line" =~ ^# ]] && continue
  week="${line%:*}"
  status="${line#*: }"
  WEEK_STATUS["$week"]="${STATUS_EMOJI[$status]}"
done < progress.txt

# 2️⃣ Backup current README
cp README.md README_backup.md

# 3️⃣ Update Progress Tracker section
PROGRESS_SECTION="# Progress Tracker\nTrack your weekly progress with emojis:\n- ⬜ Not Started\n- 🔄 In Progress\n- ✅ Completed\n\n"
for week in "${!WEEK_STATUS[@]}"; do
  PROGRESS_SECTION+="- $week : ${WEEK_STATUS[$week]}\n"
done

# 4️⃣ Update weekly links inline with emojis
# Read README line by line
NEW_README=""
while IFS= read -r line; do
  updated_line="$line"
  for week in "${!WEEK_STATUS[@]}"; do
    # Escape special chars in week name for regex
    esc_week=$(echo "$week" | sed 's/[\/&]/\\&/g')
    if [[ "$line" =~ $esc_week ]]; then
      # Append emoji to the line if not already present
      if [[ ! "$line" =~ ${STATUS_EMOJI["Completed"]}|${STATUS_EMOJI["In Progress"]}|${STATUS_EMOJI["Not Started"]} ]]; then
        updated_line="$line ${WEEK_STATUS[$week]}"
      fi
    fi
  done
  NEW_README+="$updated_line"$'\n'
done < README_backup.md

# 5️⃣ Prepend updated progress section
echo -e "$PROGRESS_SECTION\n$NEW_README" > README.md

echo "✅ README.md updated with dynamic emoji progress and inline weekly link emojis"
