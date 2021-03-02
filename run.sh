#!/bin/bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

pushd "${DIR}"
  echo
  echo "#### Run build in root directory without specifying dockerfile path and with \".\" as context directory"
  echo

  echo "$ docker build -t something ."
  docker build -t something .

  echo "$ docker run --rm -v \"${DIR}:/workspace\" -w /workspace gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace --no-push"
  docker run --rm -v "${DIR}:/workspace" -w /workspace gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace --no-push

  echo
  echo "#### Run build in subdir directory without specifying dockerfile path and with \".\" as context directory"
  echo

  pushd subdir
    echo "$ docker build -t something ."
    docker build -t something .
  popd

  echo "$ docker run --rm -v \"${DIR}:/workspace\" -w /workspace/subdir gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --no-push"
  docker run --rm -v "${DIR}:/workspace" -w /workspace/subdir gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --no-push

  echo
  echo "#### Run build in root directory without specifying dockerfile path and with \"subdir\" as context directory"
  echo

  echo "$ docker build -t something subdir"
  docker build -t something subdir

  echo "$ docker run --rm -v \"${DIR}:/workspace\" -w /workspace gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --no-push"
  docker run --rm -v "${DIR}:/workspace" -w /workspace gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --no-push

  echo
  echo "#### Run build in root directory specifying dockerfile path as \"subdir/Dockerfile\" and with \"subdir\" as context directory"
  echo

  echo "$ docker build -t something -f subdir/Dockerfile subdir"
  docker build -t something -f subdir/Dockerfile subdir

  echo "$ docker run --rm -v \"${DIR}:/workspace\" -w /workspace gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --dockerfile subdir/Dockerfile --no-push"
  docker run --rm -v "${DIR}:/workspace" -w /workspace gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --dockerfile subdir/Dockerfile --no-push

  echo
  echo "#### Run build in root directory with specifying dockerfile path as \"Dockerfile\" and with \"subdir\" as context directory"
  echo

  echo "$ docker build -t something -f Dockerfile subdir"
  docker build -t something -f Dockerfile subdir

  echo "$ docker run --rm -v \"${DIR}:/workspace\" -w /workspace gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --dockerfile=Dockerfile --no-push"
  docker run --rm -v "${DIR}:/workspace" -w /workspace gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --dockerfile=Dockerfile --no-push

  echo
  echo "#### Run build in subdir directory with specifying dockerfile path as \"../Dockerfile\" and with \".\" as context directory"
  echo

  pushd subdir
    echo "$ docker build -t something -f ../Dockerfile ."
    docker build -t something -f ../Dockerfile .
  popd

  echo "$ docker run --rm -v \"${DIR}:/workspace\" -w /workspace/source gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --dockerfile=../Dockerfile --no-push"
  docker run --rm -v "${DIR}:/workspace" -w /workspace/source gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --dockerfile=../Dockerfile --no-push

  echo
  echo "#### Run build in root directory with specifying dockerfile path as \"../Dockerfile\" and with \"subdir\" as context directory"
  echo

  echo "$ docker build -t something -f ../Dockerfile subdir"
  docker build -t something -f ../Dockerfile subdir || true

  echo "$ docker run --rm -v \"${DIR}:/workspace\" -w /workspace gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --dockerfile=../Dockerfile --no-push"
  docker run --rm -v "${DIR}:/workspace" -w /workspace gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --dockerfile=../Dockerfile --no-push

  echo
  echo "#### Run build in subdir directory with dockerfile path as \"Dockerfile\" and with \".\" as context directory"
  echo

  pushd subdir
    echo "$ docker build -t something -f Dockerfile ."
    docker build -t something -f Dockerfile  .
  popd

  echo "$ docker run --rm -v \"${DIR}:/workspace\" -w /workspace/subdir gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --dockerfile=Dockerfile --no-push"
  docker run --rm -v "${DIR}:/workspace" -w /workspace/subdir gcr.io/kaniko-project/executor:v1.5.1 --context=/workspace/subdir --dockerfile=Dockerfile --no-push
popd

echo "$ docker version"
docker version
