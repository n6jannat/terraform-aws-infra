#!/bin/bash
# Bootstraps the web server: installs Docker, runs nginx in a container,
# and adds a root-disk usage check that logs a warning above 80%.
set -euo pipefail

dnf update -y
dnf install -y docker
systemctl enable --now docker

docker run -d --name web --restart unless-stopped -p 80:80 nginx:stable

cat > /usr/local/bin/disk-check.sh <<'EOF'
#!/bin/bash
THRESHOLD=80
USAGE=$(df / --output=pcent | tail -1 | tr -dc '0-9')
if [ "$USAGE" -ge "$THRESHOLD" ]; then
  logger -t disk-check "WARNING: root disk at ${USAGE}% (threshold ${THRESHOLD}%)"
fi
EOF
chmod +x /usr/local/bin/disk-check.sh

echo "*/10 * * * * root /usr/local/bin/disk-check.sh" > /etc/cron.d/disk-check
