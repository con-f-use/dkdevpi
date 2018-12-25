
export GIT_VERSION=$(git rev-parse --abbrev-ref HEAD).$(git describe --always --dirty --abbrev)
export GIT_SHA=$(git rev-parse HEAD)
export BUILD_DATE=$(date --rfc-3339=seconds)

docker-compose stop nginx devpi || true
docker-compose build &&
  docker-compose up -d

