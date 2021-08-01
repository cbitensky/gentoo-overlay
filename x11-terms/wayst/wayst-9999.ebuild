# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple terminal emulator for Wayland and X11 with OpenGL rendering and minimal dependencies"
HOMEPAGE="https://github.com/91861/wayst"

inherit git-r3
EGIT_REPO_URI="https://github.com/91861/${PN}.git"
KEYWORDS="~amd64 ~x86"
IUSE="utf8proc wayland X"
REQUIRED_USE="|| ( wayland X )"

LICENSE="MIT"
SLOT="0"

DEPEND="
	virtual/opengl
	>=media-libs/freetype-2.10
	media-libs/fontconfig
	dev-libs/wayland
	X? (
		x11-libs/libX11
		x11-libs/libXrender
	)
	wayland? (
		dev-libs/wayland
		x11-libs/libxkbcommon
		media-libs/mesa[egl]
	)
	utf8proc? ( dev-libs/libutf8proc )
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	sed -i -r '
	s/((CFLAGS|LDFLAGS)\s*)(=.*)$/\1:\3 $(\2)/
	s|INCLUDES\s*=|&-I/usr/include/libutf8proc/ |
	' Makefile || die
	default
}

src_compile() {
	use !X       && export window_protocol=wayland
	use !wayland && export window_protocol=x11
	emake
}

src_install() {
	dobin ${PN}
}