#!/bin/sh
# Builds adblock-dns_<version>_all.ipk from ./adblock-dns
set -e

SRC_DIR="$(cd "$(dirname "$0")" && pwd)/adblock-dns"
OUT_DIR="$(cd "$(dirname "$0")" && pwd)/out"
VERSION="$(sed -n 's/^Version: //p' "$SRC_DIR/CONTROL/control")"
PKG="adblock-dns_${VERSION}_all.ipk"

TAR="tar --numeric-owner --uid 0 --gid 0"
export COPYFILE_DISABLE=1

chmod 755 "$SRC_DIR/CONTROL/postinst" "$SRC_DIR/CONTROL/prerm" "$SRC_DIR/CONTROL/postrm" \
          "$SRC_DIR/data/opt/bin/adblock-dns-update" \
          "$SRC_DIR/data/opt/bin/adblock-dns-blacklist" \
          "$SRC_DIR/data/opt/etc/init.d/S56adblock-dns"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR/stage"

echo "2.0" > "$OUT_DIR/stage/debian-binary"
(cd "$SRC_DIR/CONTROL" && $TAR -czf "$OUT_DIR/stage/control.tar.gz" .)
(cd "$SRC_DIR/data" && $TAR -czf "$OUT_DIR/stage/data.tar.gz" ./opt)
(cd "$OUT_DIR/stage" && $TAR -czf "$OUT_DIR/$PKG" ./debian-binary ./control.tar.gz ./data.tar.gz)

rm -rf "$OUT_DIR/stage"
echo "Built: $OUT_DIR/$PKG"
