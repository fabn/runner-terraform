FROM public.ecr.aws/spacelift/runner-terraform

# Terraform version to bundle; accepts an optional leading "v" so the git tag
# (e.g. v1.14.8) can be passed straight through as a build arg.
ARG TERRAFORM_VERSION=1.14.8

USER root

# Install new terraform version, see https://developer.hashicorp.com/terraform/install
RUN cd /tmp && \
    VERSION="${TERRAFORM_VERSION#v}" && \
    curl -O -sS "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip" && \
    unzip "terraform_${VERSION}_linux_amd64.zip" && \
    mv terraform /usr/local/bin/ && \
    rm "terraform_${VERSION}_linux_amd64.zip"

# Redrop privileges
USER spacelift
