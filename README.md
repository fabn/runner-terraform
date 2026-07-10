# runner-terraform

[![Latest release](https://img.shields.io/github/v/release/fabn/runner-terraform?label=latest)](https://github.com/fabn/runner-terraform/pkgs/container/runner-terraform)

Custom [Spacelift runner image](https://docs.spacelift.io/integrations/docker#customizing-the-runner-image)
bundling a newer Terraform version, published to
[`ghcr.io/fabn/runner-terraform`](https://github.com/fabn/runner-terraform/pkgs/container/runner-terraform).

## Why

Spacelift can only distribute Terraform up to **1.5.7** to its workers — the
last MPL-licensed release, since from 1.6 onwards the BUSL license forbids it.
The supported workaround is a custom runner image that ships a newer
`terraform` binary in `/usr/local/bin`: the Spacelift workflow prefers it over
the 1.5.7 binary it mounts itself (visible in the run logs as
`Using binary terraform from /usr/local/bin/terraform`).

This image extends the official `public.ecr.aws/spacelift/runner-terraform`
base and drops the desired Terraform release into `/usr/local/bin`.

## Usage

Point your stack's `runner_image` at a published tag:

```hcl
runner_image = "ghcr.io/fabn/runner-terraform:v1.14.8"
```

Every available tag is listed on the
[releases page](https://github.com/fabn/runner-terraform/releases) (one per
Terraform minor series since 1.6, pointing at its latest patch) and on the
[package page](https://github.com/fabn/runner-terraform/pkgs/container/runner-terraform).

## Releasing a new version

Releases are automated: the [Release workflow](.github/workflows/release.yml)
runs daily, computes the latest stable patch of every Terraform minor series
since 1.6, tags any version not yet released (`vX.Y.Z`), dispatches the
Docker workflow on it and creates a matching GitHub release. New patches and
new minor series are picked up automatically; its first run backfills all
past series.

Manual releases still work the same way: push a tag matching the Terraform
version you want to bundle (with a `v` prefix). The
[Docker workflow](.github/workflows/docker.yml) builds the image with
`TERRAFORM_VERSION` derived from the tag and pushes it to ghcr.io:

```sh
git tag v1.14.8
git push origin v1.14.8
# -> ghcr.io/fabn/runner-terraform:v1.14.8 (terraform 1.14.8)
```

Pull requests run a smoke build (no push). Only `linux/amd64` is built.
