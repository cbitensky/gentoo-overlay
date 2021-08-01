# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 savedconfig

DESCRIPTION="Simple keyboard based web browser"
HOMEPAGE="https://github.com/nihilowy/surfer"
EGIT_REPO_URI="https://github.com/nihilowy/surfer.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/glib:2
	net-libs/webkit-gtk:4
	x11-libs/gtk+:3
	x11-libs/libnotify
"

RDEPEND="
	${DEPEND}
"

src_prepare() {
	default
	restore_config config.h
}

src_install() {
	default
	save_config config.h
}
