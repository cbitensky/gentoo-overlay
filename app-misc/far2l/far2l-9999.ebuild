# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-utils

DESCRIPTION="Linux port of FAR v2"
HOMEPAGE="http://farmanager.com/"
EGIT_REPO_URI="https://github.com/elfmz/far2l.git"

LICENSE="GPL-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="x11-libs/wxGTK:3.0"
RDEPEND="${DEPEND}"

src_configure() {
	cmake-utils_src_configure
}
