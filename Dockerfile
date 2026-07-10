FROM public.ecr.aws/spacelift/runner-terraform

# Terraform version to bundle; accepts an optional leading "v" so the git tag
# (e.g. v1.14.8) can be passed straight through as a build arg.
ARG TERRAFORM_VERSION=1.14.8

USER root

# Install new terraform version, see https://developer.hashicorp.com/terraform/install
# The BUSL license requires conspicuously displaying it on each redistributed
# copy, so it ships in the image next to the binary. Newer release zips bundle
# LICENSE.txt; for older ones fall back to the license at the matching git tag.
RUN cd /tmp && \
    VERSION="${TERRAFORM_VERSION#v}" && \
    curl -O -sS "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip" && \
    unzip -o "terraform_${VERSION}_linux_amd64.zip" && \
    mv terraform /usr/local/bin/ && \
    if [ ! -f LICENSE.txt ]; then \
      curl -o LICENSE.txt -sSf "https://raw.githubusercontent.com/hashicorp/terraform/v${VERSION}/LICENSE"; \
    fi && \
    mkdir -p /usr/local/share/doc/terraform && \
    mv LICENSE.txt /usr/local/share/doc/terraform/LICENSE.txt && \
    rm "terraform_${VERSION}_linux_amd64.zip"

# Redrop privileges
USER spacelift
