#!/usr/bin/env bash
set -euo pipefail

# 설치 스크립트: frontend에서 liberty 스킨을 빌드하여 ./skins/liberty에 배치하고
# 이후 Docker Compose로 TheTree 엔진을 빌드/시작하는 안내 스크립트입니다.

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT_DIR"

SKIN_NAME=liberty
FRONT_REPO="https://github.com/wjdgustn/thetree-frontend.git"

# 1) frontend 소스가 없으면 클론
if [ ! -d "frontend" ]; then
  echo "Cloning frontend repo: $FRONT_REPO"
  git clone "$FRONT_REPO" frontend
else
  echo "frontend 폴더가 이미 존재합니다. 최신으로 업데이트합니다."
  (cd frontend && git fetch --all && git reset --hard origin/master)
fi

# 2) 의존성 설치
echo "Installing frontend dependencies (npm ci)..."
cd frontend
npm ci --no-audit --progress=false

# 3) 스킨 빌드 (TheTree 빌드 명령 시도)
echo "Building skin: $SKIN_NAME"
mkdir -p "$ROOT_DIR/skins/$SKIN_NAME"

# Vite 빌드 시도 (server + client)
# 일부 frontend 레포는 다른 빌드 명령을 사용할 수 있습니다. 실패해도 스크립트는 계속됩니다.
npx vite build --emptyOutDir --outDir "$ROOT_DIR/skins/$SKIN_NAME/server" --ssr src/server.js || echo "server build failed (non-fatal)"
npx vite build --emptyOutDir --outDir "$ROOT_DIR/skins/$SKIN_NAME/client" --ssrManifest || echo "client build failed (non-fatal)"

# 4) 빌드 결과 확인
echo "Built files in:"
ls -la "$ROOT_DIR/skins/$SKIN_NAME" || true

# 5) Docker Compose로 서비스 시작 안내
cd "$ROOT_DIR"

echo "준비 완료: 이제 Docker Compose로 TheTree 엔진을 시작할 수 있습니다."
echo "1) .env 파일을 확인/수정하세요 (.env 또는 .env.example 사용)."
echo "2) 다음 명령으로 컨테이너 빌드+시작하세요:"
echo "   docker compose up -d --build"
echo "3) 로그 확인: docker compose logs -f app"

echo "주의: MongoDB, Redis, MeiliSearch 등 서비스가 compose로 함께 시작됩니다."
