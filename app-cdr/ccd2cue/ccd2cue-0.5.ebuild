# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="The GNU CCD (CloneCD) sheet to CUE sheet converter"
HOMEPAGE="https://www.gnu.org/software/ccd2cue/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~amd64"

src_configure() {
	econf \
		--disable-doxygen-chi \
		--disable-doxygen-chm \
		--disable-doxygen-doc \
		--disable-doxygen-dot \
		--disable-doxygen-html \
		--disable-doxygen-man \
		--disable-doxygen-pdf \
		--disable-doxygen-ps \
		--disable-doxygen-rtf \
		--disable-doxygen-xml \
		--disable-nls
}
