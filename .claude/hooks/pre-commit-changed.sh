#!/usr/bin/env bash
# Stop hook for Claude Code: runs the pre-commit checks on what changed in the working tree.
# Exit 2 hands the output to the agent and keeps its turn open. Any other failure only shows
# a notice to the person at the keyboard.

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
	echo "jq is not installed, the checks did not run" >&2
	exit 1
fi

# CLAUDE_PROJECT_DIR names the main checkout even while the session works in a worktree of it.
# The hook input names the directory the session is in. If that is not a checkout of this
# repository, the main checkout is checked.
repository() { git -C "$1" rev-parse --path-format=absolute --git-common-dir 2>/dev/null; }
tree=$(git -C "$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)" rev-parse --show-toplevel 2>/dev/null)
if [ -z "$tree" ] || [ "$(repository "$tree")" != "$(repository "$CLAUDE_PROJECT_DIR")" ]; then
	tree=$CLAUDE_PROJECT_DIR
fi
cd "$tree" || exit 0

# Nothing changed, so there is nothing to check and no reason to set up the tools the
# configuration names.
[ -z "$(git status --porcelain)" ] && exit 0

if ! command -v pre-commit >/dev/null 2>&1; then
	echo "pre-commit is not installed, the checks did not run" >&2
	exit 1
fi

if ! output=$(pre-commit install-hooks 2>&1); then
	printf 'pre-commit could not set up its tools, the checks did not run\n%s\n' "$output" >&2
	exit 1
fi

output=$(
	{
		git diff --name-only -z HEAD
		git ls-files -z --others --exclude-standard
	} | xargs -0 pre-commit run --files 2>&1
) && exit 0

# The agent already had one turn to fix this. Holding it again would loop on anything it
# cannot fix, such as a file that belongs to someone else.
if [ "$(jq -r '.stop_hook_active' <<<"$input" 2>/dev/null)" = true ]; then
	printf 'pre-commit still fails after one retry. Files that are not part of the work belong in .git/info/exclude.\n%s\n' "$output" >&2
	exit 1
fi

printf '%s\n\nFix what you created or changed in this turn. Leave files you did not touch as they are and name them in your reply.\n' "$output" >&2
exit 2
