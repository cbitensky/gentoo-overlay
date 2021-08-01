# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Flat Assembler"
HOMEPAGE="http://flatassembler.net/"
SRC_URI="http://flatassembler.net/fasm-${PV}.tgz"

S="${WORKDIR}/fasm"

LICENSE="fasm"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples tools"
QA_PREBUILT="*"

src_install() {
	use amd64 && mv -f fasm.x64 fasm
	dobin fasm
	dodoc license.txt whatsnew.txt
	use doc && dodoc fasm.txt
	for flag in examples tools; do
		if use $flag; then
			insinto /usr/share/${PN}
			doins -r $flag
		fi
	done
}
