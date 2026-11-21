#!/usr/bin/env bash
# Integrate this harness into the repository you are standing in.
# Run from the target repository root:  bash /path/to/harness-loop/integrate.sh
# Shared files are overwritten (update the harness); tasks/, backlog/ notes and config.json are never touched.
set -eu
src=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
dest="$PWD/.harness-loop"

mkdir -p "$dest/tasks" "$dest/archived-tasks" "$dest/backlog" "$dest/task-assets"
for file in runner.py selftest.py rules.md .gitignore config.example.json README.md backlog/sample-task.md; do
    cp "$src/$file" "$dest/$file"
    echo "  updated .harness-loop/$file"
done
# task-assets: seed the folder and its ignore rules only when missing; never overwrite
for file in task-assets/.gitignore task-assets/.gitkeep; do
    if [ ! -f "$dest/$file" ]; then
        cp "$src/$file" "$dest/$file"
        echo "  seeded .harness-loop/$file"
    fi
done
if [ ! -f "$dest/config.json" ]; then
    cp "$src/config.example.json" "$dest/config.json"
    echo "  created .harness-loop/config.json from the example - fill in verify_commands, source_globs, test_globs"
else
    echo "  kept existing .harness-loop/config.json"
fi
echo
echo "Next: from this repo root, run"
echo "  python3 .harness-loop/selftest.py"
echo "  python3 .harness-loop/runner.py --dry-run"
