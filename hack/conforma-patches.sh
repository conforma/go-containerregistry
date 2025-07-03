#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

patches=(
  https://github.com/zregvart/go-containerregistry.git
  pr/credential-lookup
  1966

  https://github.com/lcarva/go-containerregistry.git
  ignore-malformed-secrets
  1834
)

for ((i = 0; i < ${#patches[@]}; i += 3)); do
  url="${patches[i]}"
  branch="${patches[i+1]}"
  upstream_pr="${patches[i+2]}"

  remote="$(tmp="${url%/*}"; echo "${tmp##*/}")"

  git remote add --no-fetch "${remote}" "${url}" || true # ignore if it already exists
  git fetch "${remote}" "${branch}"
  git merge \
    -m "Merge ${remote}/${branch} (#${upstream_pr})" \
    -m "See https://github.com/google/go-containerregistry/pull/${upstream_pr}" \
    "${remote}/${branch}"
done
