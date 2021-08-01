# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

ABBREV="doublecmd"
DESCRIPTION="Cross Platform file manager"
HOMEPAGE="http://${ABBREV}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${ABBREV}/${ABBREV}-${PV}-src.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk qt"
REQUIRED_USE="^^ ( gtk qt )"
RESTRICT="strip"
DEPEND=">=dev-lang/lazarus-1.8[-minimal]"
RDEPEND="
	${DEPEND}
	sys-apps/dbus
	dev-libs/glib
	sys-libs/ncurses
	x11-libs/libX11
	gtk? ( x11-libs/gtk+:2 )
	qt? ( >=dev-qt/qtcore-5.6
		>=dev-libs/libqt5pas-2.6 )
"

S="${WORKDIR}/${ABBREV}-${PV}"

src_prepare(){
	eapply_user
	find ./ -type f -name "build.sh" -exec sed -i 's#$lazbuild #$lazbuild --pcp=~/.lazarus --lazarusdir=/usr/share/lazarus #g' {} \;
	sed -i '/Einstellungen/ d' components/CmdLine/cmdbox.lpk
}

src_compile(){
	use gtk && export lcl="gtk2"
	use qt  && export lcl="qt5"
	HOME="${PORTAGE_BUILDDIR}/homedir" lazpath="/usr/share/lazarus" ./build.sh 
	HOME="${PORTAGE_BUILDDIR}/homedir" lazpath="/usr/share/lazarus" ./build.sh beta || die
}

src_install(){
	install/linux/install.sh --install-prefix="${D}"
}
