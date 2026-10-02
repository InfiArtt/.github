#!/usr/bin/env bash
# Gives every public, non-archived repository in the organization the
# standard default-branch ruleset (rulesets/protect-default-branch.json),
# if it doesn't have it yet. Existing rulesets are never changed.
#
# Needs GH_TOKEN: a fine-grained token from an organization owner with
# "Administration: Read and write" on all repositories (ORG_ADMIN_TOKEN).
set -euo pipefail

ORG="${ORG:?ORG is not set}"
RULESET_FILE="rulesets/protect-default-branch.json"
NAME="$(jq -r .name "$RULESET_FILE")"
SUMMARY="${GITHUB_STEP_SUMMARY:-/dev/stdout}"

if [ -z "${GH_TOKEN:-}" ]; then
	echo "::warning::The ORG_ADMIN_TOKEN secret is not set, so no repository was checked. See scripts/protect-repos.sh."
	echo "ORG_ADMIN_TOKEN is not set yet: nothing was checked." >> "$SUMMARY"
	exit 0
fi

protected=()
failed=()
for repo in $(gh api --paginate "orgs/$ORG/repos?type=public&per_page=100" -q '.[] | select(.archived | not) | .name'); do
	if gh api "repos/$ORG/$repo/rulesets" -q '.[].name' | grep -Fxq "$NAME"; then
		continue
	fi
	if gh api -X POST "repos/$ORG/$repo/rulesets" --input "$RULESET_FILE" > /dev/null; then
		echo "Protected $repo"
		protected+=("$repo")
	else
		echo "::error::Could not add the ruleset to $repo"
		failed+=("$repo")
	fi
done

{
	echo "## Default-branch protection"
	if [ ${#protected[@]} -eq 0 ] && [ ${#failed[@]} -eq 0 ]; then
		echo "Every public repository is already protected."
	fi
	for repo in "${protected[@]}"; do echo "- Protected **$repo**"; done
	for repo in "${failed[@]}"; do echo "- Failed: **$repo**"; done
} >> "$SUMMARY"

[ ${#failed[@]} -eq 0 ]
