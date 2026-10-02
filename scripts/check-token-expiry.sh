#!/usr/bin/env bash
# Opens an issue in this repository when ORG_ADMIN_TOKEN expires within
# 14 days, so an owner can create a new one in time.
#
# Needs ADMIN_TOKEN (the token to check) and GH_TOKEN (GITHUB_TOKEN with
# issues: write, to open the reminder).
set -euo pipefail

[ -n "${ADMIN_TOKEN:-}" ] || exit 0

expiry="$(curl -sSI -H "Authorization: Bearer $ADMIN_TOKEN" https://api.github.com/user \
	| tr -d '\r' | sed -n 's/^github-authentication-token-expiration: //Ip')"
if [ -z "$expiry" ]; then
	echo "The token has no expiry date."
	exit 0
fi

days_left=$(( ( $(date -d "$expiry" +%s) - $(date +%s) ) / 86400 ))
echo "ORG_ADMIN_TOKEN expires on $expiry ($days_left days left)."
[ "$days_left" -le 14 ] || exit 0

title="ORG_ADMIN_TOKEN expires soon"
if gh issue list --repo "$GITHUB_REPOSITORY" --state open --search "\"$title\" in:title" --json number -q '.[0].number' | grep -q .; then
	echo "A reminder issue is already open."
	exit 0
fi
gh issue create --repo "$GITHUB_REPOSITORY" --title "$title" --body "The token used by the **Protect new repositories** workflow expires on **$expiry** ($days_left days left).

An organization owner should create a new fine-grained token with the same settings (resource owner InfiArtt, all repositories, Administration: Read and write) and replace the ORG_ADMIN_TOKEN secret in this repository's settings. Then close this issue."
