# Crust

> A repository used to create up-to-date images for fully automated operation of [Kubernetes (k3s)][k3s-url] on 
> Raspberry Pis with configuration using [cloud-init][cloud-init-url].

## \[WIP\]

> THIS REPOSITORY IS A WORK-IN-PROGRESS; IMAGES ARE NOT YET PUBLISHED!

## Tools

The following tools are installed and available in the image:

| Name              | Documentation                                                 |
| ----------------- | ------------------------------------------------------------- |
| cloud-init        | [Documentation][cloud-init-url] [License][cloud-init-license] |
| cosign            | [Documentation][cosign-url] [License][cosign-license]         |
| crane             | [Documentation][crane-url] [License][crane-license]           |
| flux              | [Documentation][flux-url] [License][flux-license]             |
| gitops            | [Documentation][gitops-url] [License][gitops-license]         |
| k3s               | [Documentation][k3s-url] [License][k3s-license]               |
| k3s airgap images | [Documentation][k3s-airgap-url] [License][k3s-license]        |
| oras              | [Documentation][oras-url] [License][oras-license]             |

## Features

* support for [cloud-init][cloud-init-url] to easily configure the cluster in a reproducible way without requiring image 
  rebuilds
  * automatically bootstrap [k3s][k3s-url] for cluster, server, or agent
  * automatically bootstrap [flux][flux-url]
* [k3s air-gap][k3s-airgap-url] images are included in the image to avoid image pulls on start
* kube config is symlinked for every user, including those created by [cloud-init][cloud-init-url]
  * this helps ensure that third-party tools that rely on the kube config `just work`
* kernel and all linux packages are up-to-date with the latest available as of the time of build
* kernel is flashed on first start if new kernel is available
  * this will not keep the kernel up to date over time, so re-imaging will be necessary

## How it Works

This repository uses [packer][packer-url] to download the latest upstream image and repackage it to include additional
tooling, including [k3s][k3s-url] and [cloud-init][cloud-init-url]. Packer itself is executed within an OCI container
using binfmt and qemu to enable builds on varying source architectures.

To create new images using the [containerd][containerd-url] runtime via [nerdctl][nerdctl-url]:

```sh
make
```

We recommend using [colima][colima-url] on macOS to create a suitable [containerd][containerd-url] runtime:

```sh
brew install colima

colima start --runtime=containerd --cpu=4 --memory=16 --disk=64
```

## Notice

The Raspberry Pi may reboot on the first boot from a newly flashed SD card, which is done to upgrade the kernel. This is
managed by the [00-upgrade-kernel.cfg](./overlay/etc/cloud/cloud.cfg.d/00-upgrade-kernel.cfg) which executes
the [upgrade-kernel](./overlay/usr/local/bin/upgrade-kernel) script. This script flashes the kernel and creates a
marker file used by cloud-init to detect when a reboot is required. On subsequent boots, the script will remove the
marker file and the system will start as normal.

[cloud-init-url]: https://cloudinit.readthedocs.io
[cloud-init-license]: https://github.com/canonical/cloud-init/blob/main/LICENSE
[cosign-url]: https://docs.sigstore.dev/cosign/overview
[cosign-license]: https://github.com/sigstore/docs/blob/main/LICENSE
[crane-url]: https://github.com/google/go-containerregistry/blob/main/cmd/crane/doc/crane.md
[crane-license]: https://github.com/google/go-containerregistry/blob/main/LICENSE
[flux-url]: https://fluxcd.io
[flux-license]: https://github.com/fluxcd/flux2/blob/main/LICENSE
[gitops-url]: https://docs.gitops.weave.works/docs/references/cli-reference/gitops/
[gitops-license]: https://github.com/weaveworks/weave-gitops/blob/main/LICENSE
[k3s-url]: https://k3s.io
[k3s-license]: https://github.com/k3s-io/k3s/blob/master/LICENSE
[k3s-airgap-url]: https://docs.k3s.io/installation/airgap
[oras-url]: https://oras.land
[oras-license]: https://github.com/oras-project/oras/blob/main/LICENSE
[packer-url]: https://www.packer.io/
[packer-license]: https://github.com/hashicorp/packer/blob/main/LICENSE
[colima-url]: https://github.com/abiosoft/colima
[colima-license]: https://github.com/abiosoft/colima/blob/main/LICENSE
[containerd-url]: https://containerd.io
[containerd-license]: https://github.com/containerd/containerd/blob/main/LICENSE
[nerdctl-url]: https://github.com/containerd/nerdctl
[nerdctl-license]: https://github.com/containerd/nerdctl/blob/master/LICENSE
