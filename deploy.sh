#!/usr/bin/env bash
#
# deploy.sh — Sube los cambios a producción (git push a origin/main)
#
# Uso:
#   ./deploy.sh                 -> commitea todo con un mensaje automático y hace push
#   ./deploy.sh "mi mensaje"    -> usa tu mensaje de commit
#
set -euo pipefail

# Ir a la carpeta del repo (donde está este script)
cd "$(dirname "$0")"

# Mensaje de commit: argumento, o uno automático con fecha/hora
MSG="${1:-deploy: $(date '+%Y-%m-%d %H:%M:%S')}"

echo "==> Cambios detectados:"
git status --short

# Si no hay nada que commitear, igual intentamos push por si hay commits locales pendientes
if [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -m "$MSG"
else
  echo "==> No hay cambios sin commitear."
fi

echo "==> Haciendo push a origin/main..."
git push origin main

echo "==> Listo. Cambios reflejados en producción."
