#!/usr/bin/env bash
# ssh-key-installer: safely add a public SSH key to ~/.ssh/authorized_keys.
#
# Usage:
#   ./setup-ssh-key.sh                 prompt for the key
#   ./setup-ssh-key.sh "ssh-ed25519 AAAA... comment"
#   ./setup-ssh-key.sh -f ~/.ssh/id_ed25519.pub
#   echo "ssh-ed25519 AAAA..." | ./setup-ssh-key.sh
#
# Environment: SSH_DIR overrides the target directory (default: ~/.ssh).

set -euo pipefail

usage() {
  sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

KEY=""
while getopts ":f:h" opt; do
  case "$opt" in
    f) [ -r "$OPTARG" ] || { echo "Error: cannot read file: $OPTARG" >&2; exit 1; }
       KEY="$(head -n 1 "$OPTARG")" ;;
    h) usage 0 ;;
    *) echo "Error: unknown option or missing argument: -${OPTARG:-?}" >&2; echo "Hint: a private key must never be passed here. Use the .pub file." >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

if [ -z "$KEY" ]; then
  if [ "$#" -ge 1 ]; then
    KEY="$*"
  elif [ ! -t 0 ]; then
    IFS= read -r KEY || true
  else
    echo "======================================"
    echo " SSH Public Key Installer"
    echo "======================================"
    IFS= read -r -p "Paste your public SSH key: " KEY
  fi
fi

# trim surrounding whitespace and CR
KEY="$(printf '%s' "$KEY" | tr -d '\r' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"

if [ -z "$KEY" ]; then
  echo "Error: no key given." >&2; exit 1
fi
case "$KEY" in
  *PRIVATE\ KEY*)
    echo "Error: this looks like a PRIVATE key. Never share it. Use the .pub file." >&2; exit 1 ;;
esac
if ! printf '%s' "$KEY" | grep -Eq '^(ssh-(rsa|ed25519|dss)|ecdsa-sha2-nistp(256|384|521)|sk-ssh-ed25519@openssh\.com|sk-ecdsa-sha2-nistp256@openssh\.com) [A-Za-z0-9+/=]+( .*)?$'; then
  echo "Error: not a valid OpenSSH public key (expected e.g. 'ssh-ed25519 AAAA... comment')." >&2; exit 1
fi
if command -v ssh-keygen >/dev/null 2>&1; then
  TMP="$(mktemp)"; trap 'rm -f "$TMP"' EXIT
  printf '%s\n' "$KEY" > "$TMP"
  ssh-keygen -l -f "$TMP" >/dev/null 2>&1 || { echo "Error: ssh-keygen rejects this key." >&2; exit 1; }
fi

SSH_DIR="${SSH_DIR:-$HOME/.ssh}"
AUTH="$SSH_DIR/authorized_keys"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
touch "$AUTH"
chmod 600 "$AUTH"

if grep -qxF -- "$KEY" "$AUTH"; then
  echo "Key is already installed. Nothing to do."
  exit 0
fi

# make sure the last existing line ends with a newline before appending
if [ -s "$AUTH" ] && [ "$(tail -c 1 "$AUTH" | wc -l)" -eq 0 ]; then
  printf '\n' >> "$AUTH"
fi
printf '%s\n' "$KEY" >> "$AUTH"

echo "SSH key installed in $AUTH."
echo "You can now connect without a password (if the server allows public key login)."
