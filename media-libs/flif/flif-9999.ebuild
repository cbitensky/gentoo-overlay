# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils git-r3

DESCRIPTION="FLIF is the Free Lossless Image Format"
HOMEPAGE="http://flif.info"
EGIT_REPO_URI="git://github.com/FLIF-hub/FLIF.git
				https://github.com/FLIF-hub/FLIF"
LICENSE="GPL-3+ LGPL-3+ Apache-2.0"
SLOT="0"
IUSE="-viewflif +decoder +pixbuf"

DEPEND="media-libs/libpng
		viewflif? ( media-libs/libsdl2 )
		pixbuf? ( x11-libs/gdk-pixbuf )
		sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -r "s%/lib([^a-z]|\$)%/$(get_libdir)\1%g" $S/src/Makefile || die "sed failed"
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
	if use pixbuf; then
		emake pixbufloader
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
	if use pixbuf; then
		# pixbufloader uses absolute paths, so ignore the Makefile entry and
		# do it manually
		exeinto /usr/$(get_libdir)/gdk-pixbuf-2.0/2.10.0/loaders
		doexe libpixbufloader-flif.so
	fi
}

pkg_postinst() {
	if use pixbuf; then
		gdk-pixbuf-query-loaders --update-cache
		xdg-mime install --novendor flif-mime.xml
	fi
}
