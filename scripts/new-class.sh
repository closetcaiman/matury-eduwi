#!/usr/bin/env bash
# Usage: scripts/new-class.sh [slug] [--date YYYY-MM-DD]
# Creates classes/NN-YYYY-MM-DD[-slug]/{board.excalidraw,src/main.cpp} with NN = highest existing + 1.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
classes="$root/classes"

usage() { echo "usage: $0 [slug] [--date YYYY-MM-DD]" >&2; exit 1; }

slug=""
date="$(date +%F)"
while (($#)); do
    case "$1" in
        --date) [[ $# -ge 2 ]] || usage; date="$2"; shift 2 ;;
        -h|--help) usage ;;
        -*) echo "unknown option: $1" >&2; usage ;;
        *) [[ -z "$slug" ]] || usage; slug="$1"; shift ;;
    esac
done

if [[ -n "$slug" && ! "$slug" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo "invalid slug '$slug': use only a-z, 0-9 and single hyphens (no Polish letters)" >&2
    exit 1
fi
if [[ ! "$date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || [[ "$(date -d "$date" +%F 2>/dev/null)" != "$date" ]]; then
    echo "invalid date '$date': expected YYYY-MM-DD" >&2
    exit 1
fi

max=0
shopt -s nullglob
for d in "$classes"/[0-9]*/; do
    n="$(basename "$d")"
    n="${n%%-*}"
    ((10#$n > max)) && max=$((10#$n))
done

name="$(printf '%02d-%s' $((max + 1)) "$date")${slug:+-$slug}"
dir="$classes/$name"

mkdir -p "$dir/src"
cp "$root/scripts/templates/main.cpp" "$dir/src/main.cpp"
sed "s/\"Matury EduWI\"/\"Matury EduWI $date\"/g" "$root/scripts/templates/board.excalidraw" > "$dir/board.excalidraw"
echo "classes/$name"
