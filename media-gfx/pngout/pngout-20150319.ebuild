# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="One more PNG-optimizer"
HOMEPAGE="http://www.jonof.id.au/kenutils"
SRC_URI="http://static.jonof.id.au/dl/kenutils/${P}-linux.tar.gz"
RESTRICT="mirror"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
QA_PREBUILT="*"

S="${WORKDIR}/${P}-linux"

src_install() {
	use amd64 && SUBDIR=x86_64 || SUBDIR=i686
	dobin ${S}/${SUBDIR}/${PN}

	insinto "/usr/share/doc/${PN}"
	dodoc ${WORKDIR}/${P}-linux/readme.txt
}
