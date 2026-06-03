#!/usr/bin/env bash
# Generate the SSH keypair Ansible uses to connect to the test container.
# Idempotent: does nothing if the key already exists.
#
# The keypair lives in keys/ which is gitignored, so the private key never
# reaches the public repository. The public key is baked into the image at
# build time (see docker/Dockerfile).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
KEY_DIR="${REPO_ROOT}/keys"
KEY_PATH="${KEY_DIR}/id_ansible"

mkdir -p "${KEY_DIR}"

if [[ -f "${KEY_PATH}" ]]; then
  echo "[gen_keys] Key already exists at ${KEY_PATH}, nothing to do."
  exit 0
fi

ssh-keygen -t ed25519 -N "" -C "ansible@static-server" -f "${KEY_PATH}"
chmod 600 "${KEY_PATH}"
chmod 644 "${KEY_PATH}.pub"

echo "[gen_keys] Generated keypair:"
echo "  private: ${KEY_PATH}"
echo "  public : ${KEY_PATH}.pub"
