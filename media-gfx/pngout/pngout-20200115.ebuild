# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Produces extremely well compressed PNG images"
HOMEPAGE="http://www.jonof.id.au/kenutils"
F=${P}-linux
SRC_URI="http://www.jonof.id.au/files/kenutils/${F}.tar.gz"
RESTRICT="mirror"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
QA_PREBUILT="*"

S="${WORKDIR}/${F}"

src_install() {
	use amd64 && SUBDIR=amd64 || SUBDIR=i686
	dobin ${S}/${SUBDIR}/${PN}
	dodoc readme.txt
}
