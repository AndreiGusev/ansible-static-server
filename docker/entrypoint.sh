#!/usr/bin/env bash
# Start sshd via the init script, then keep the container alive as PID 1.
#
# Why not run `sshd -D` as PID 1? Because the ssh hardening role restarts the
# service (service ssh restart). If sshd were PID 1, restarting it would kill
# the container. Running `sleep infinity` as PID 1 keeps the container up while
# sshd can be freely (re)started by Ansible.
set -euo pipefail

# Ensure the host keys exist (idempotent; only generates missing keys).
ssh-keygen -A

service ssh start

echo "[entrypoint] sshd started, container ready."

exec sleep infinity
