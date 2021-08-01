# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit desktop xdg git-r3 autotools

DESCRIPTION="A lightweight email client and newsreader"
HOMEPAGE="https://github.com/v1cont/yam"
EGIT_REPO_URI="https://github.com/v1cont/${PN}.git"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="crypt ipv6 ldap nls oniguruma spell ssl xface"

CDEPEND="net-libs/liblockfile
	x11-libs/gtk+:3
	crypt? ( app-crypt/gpgme )
	ldap? ( net-nds/openldap )
	nls? ( sys-devel/gettext )
	oniguruma? ( dev-libs/oniguruma:= )
	spell? (
		app-text/gtkspell:3
		dev-libs/dbus-glib
	)
	ssl? (
		dev-libs/openssl:0=
	)"
RDEPEND="${CDEPEND}
	app-misc/mime-types
	net-misc/curl"
DEPEND="${CDEPEND}
	xface? ( media-libs/compface )"
BDEPEND="virtual/pkgconfig"

DOCS="AUTHORS COPYING* README* TODO*"

src_prepare() {
    eautoreconf
    eapply_user
}

src_configure() {
	local htmldir="${EPREFIX}"/usr/share/doc/${PF}/html
	econf \
		$(use_enable crypt gpgme) \
		$(use_enable ipv6) \
		$(use_enable ldap) \
		$(use_enable oniguruma) \
		$(use_enable spell gtkspell) \
		$(use_enable ssl) \
		$(use_enable xface compface) \
		--with-plugindir="${EPREFIX}"/usr/$(get_libdir)/${PN}/plugins \
		--with-manualdir="${htmldir}"/manual \
		--with-faqdir="${htmldir}"/faq \
		--disable-updatecheck
}

src_install() {
	default

#	doicon *.png
#	domenu *.desktop

#	cd plugin/attachment_tool
#	emake DESTDIR="${D}" install-plugin
#	docinto plugin/attachment_tool
#	dodoc README
}
