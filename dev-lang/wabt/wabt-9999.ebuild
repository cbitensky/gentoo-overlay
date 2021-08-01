# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 cmake-utils
EGIT_REPO_URI="https://github.com/WebAssembly/wabt"
DESCRIPTION="The WebAssembly Binary Toolkit"
HOMEPAGE=$EGIT_REPO_URI
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND="
	"

EGIT_CLONE_TYPE=shallow
EGIT_SUBMODULES=()

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=OFF
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}