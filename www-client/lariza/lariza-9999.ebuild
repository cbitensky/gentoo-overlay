# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3

DESCRIPTION="Simple WebKit2GTK+ Browser"
HOMEPAGE="https://www.uninformativ.de/git/lariza/"
EGIT_REPO_URI="https://www.uninformativ.de/git/lariza.git"
EGIT_CLONE_TYPE="single"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/glib:2
	net-libs/webkit-gtk:4
	x11-libs/gtk+:3
"

RDEPEND="
	${DEPEND}
"

src_prepare(){
	sed -i 's|prefix = /usr/local|prefix = /usr|' Makefile
	eapply_user
}

src_install() {
	default
	desktop="${T}/${PN}.desktop"

	cat <<-EOF > "${desktop}" || die
	[Desktop Entry]
	Type=Application
	Name=${PN^}
	Comment=${DESCRIPTION}
	Exec=${PN} %u
	MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https
	Categories=Network;WebBrowser
	EOF

	insinto /usr/share/applications
	doins "${desktop}"
}
