#!/bin/bash -ex
GH_RUNNER_VERSION=$1

case $(uname -m) in
  x86_64 | amd64)
    export TARGET_ARCH="x64"
    ;;
  aarch64 | arm64)
    export TARGET_ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture: $(uname -m)"
    exit 1
    ;;
esac

if [[ $GH_RUNNER_VERSION == "latest" ]] ; then
  RUNNER_URL=$(curl -s https://api.github.com/repos/actions/runner/releases/latest \
  | grep "browser_download_url.*tar.gz" \
  | grep "linux-${TARGET_ARCH}" \
  | cut -d ':' -f 2,3 \
  | tr -d "\" ")
else
  RUNNER_URL="https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-${TARGET_ARCH}-${GH_RUNNER_VERSION}.tar.gz"
fi
curl -L $RUNNER_URL -o actions.tar.gz
tar -zxf actions.tar.gz
rm -f actions.tar.gz
./bin/installdependencies.sh
mkdir -p /_work
