#!/bin/sh
# Regenerates the blacklist.txt shipped in the package by running the
# packaged generator against the in-repo copy of /opt/etc/adblock-dns.
set -e

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
exec "$BASE_DIR/adblock-dns/data/opt/bin/adblock-dns-blacklist" \
     "$BASE_DIR/adblock-dns/data/opt/etc/adblock-dns"
