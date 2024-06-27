# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A container runtime for running containers in virtual machines"
HOMEPAGE="https://katacontainers.io/"
SRC_URI="
	https://github.com/kata-containers/kata-containers/archive/refs/tags/${PV}.tar.gz -> kata-containers-${PV}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	app-misc/yq-go
	>dev-lang/go-1.22.2
"

S="${WORKDIR}"/kata-containers-"${PV}"
GOPATH="${WORKDIR}"/go

src_prepare() {
	mkdir -p "${GOPATH}"/bin || die "Failed to create ${GOPATH}"
	ln -s /usr/bin/yq-go "${GOPATH}"/bin/yq || die "Failed to create yq symlink"

	sed -i -e '/CGO_CPPFLAGS/d' src/runtime/Makefile \
		|| die "Failed to remove CGO_CPPFLAGS from src/runtime/Makefile"
	default
}

src_compile() {
	emake -C src/runtime DESTDIR="${D}" PREFIX=/usr GOPATH="${GOPATH}"
}

src_install() {
	emake -C src/runtime DESTDIR="${D}" PREFIX=/usr GOPATH="${GOPATH}" install
}
