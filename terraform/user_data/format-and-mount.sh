# !/usr/bin/env bash
set -euxo pipefail

# 1) 새로 붙은 데이터 디스크 찾기 (루트 sda/xvda 제외)
#    환경에 따라 /dev/vdb 또는 /dev/xvdb 로 잡힘
DEV=""
for CAND in /dev/vdb /dev/xvdb; do
  if [ -b "$CAND" ]; then DEV="$CAND"; break; fi
done

# 2) 장치가 늦게 attach될 수 있으니 최대 5분(60*5s) 기다림
i=0
while [ -z "$DEV" ] && [ $i -lt 60 ]; do
  sleep 5
  for CAND in /dev/vdb /dev/xvdb; do
    if [ -b "$CAND" ]; then DEV="$CAND"; break; fi
  done
  i=$((i+1))
done

# 디스크가 끝까지 안 나타났다면 조용히 종료(다음 부팅/수동 처리)
[ -z "$DEV" ] && exit 0

PART="${DEV}1"

# 3) parted/mkfs 존재 보장
if ! command -v parted >/dev/null; then
  apt-get update -y || true
  apt-get install -y parted || true
fi

# 4) 파티션/포맷(멱등: 이미 돼 있으면 건너뜀)
if ! blkid "$PART" >/dev/null 2>&1; then
  parted -s "$DEV" mklabel gpt
  parted -s "$DEV" mkpart primary ext4 0% 100%
  mkfs.ext4 -L data100 "$PART"
fi

# 5) 마운트 포인트 생성 및 fstab 등록(중복 방지)
mkdir -p /data
grep -q 'LABEL=data100' /etc/fstab || echo 'LABEL=data100 /data ext4 defaults,nofail 0 2' >> /etc/fstab

# 6) 현재 세션에 마운트(이미 마운트돼 있으면 통과)
mountpoint -q /data || mount /data
