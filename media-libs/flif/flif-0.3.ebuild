# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="FLIF is the Free Lossless Image Format"
HOMEPAGE="http://flif.info"
SRC_URI="https://github.com/FLIF-hub/FLIF/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FLIF-${PV}"

LICENSE="GPL-3+ LGPL-3+ Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="-viewflif +decoder"

DEPEND="media-libs/libpng
		viewflif? ( media-libs/libsdl2 )
		sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	# recommended by Gentoo
	epatch_user
}

src_compile() {
	emake
	cd src/
	if use decoder; then
		emake decoder
	fi
	if use viewflif; then
		emake viewflif
	fi
}

src_install() {
	cd src/
	emake PREFIX="${D}/usr" install
	emake PREFIX="${D}/usr" install-dev
	if use decoder; then
		emake PREFIX="${D}/usr" install-decoder
	fi
	if use viewflif; then
		emake PREFIX="${D}/usr" install-viewflif
	fi
}
