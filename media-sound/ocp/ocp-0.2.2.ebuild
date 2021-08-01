EAPI=7
inherit flag-o-matic
DESCRIPTION="A console module player"
HOMEPAGE="http://stian.lunafish.org/"

SRC_URI="https://stian.cubic.org/ocp/${P}.tar.xz \
         ftp://ftp.cubic.org/pub/player/gfx/opencp25image1.zip \
         ftp://ftp.cubic.org/pub/player/gfx/opencp25ani1.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86_64"

IUSE="debug X adplug sidplay alsa flac"
RDEPEND="media-libs/libmad
    media-libs/libid3tag
    media-libs/libogg
    media-libs/libvorbis
    sidplay? ( <media-libs/libsidplay-2.0 )
    sidplay? ( >=media-libs/libsidplay-1.36 )
	X? (
		x11-libs/libXext
		x11-libs/libXxf86vm
		x11-libs/libX11
	)
	alsa? ( media-libs/alsa-lib )
	adplug? ( media-libs/adplug )
	flac? ( media-libs/flac )
	media-sound/timidity-eawpatches
    "
DEPEND="$RDEPEND"

src_configure() {
	econf --exec-prefix=/usr $(use_with debug) $(use_with adplug) $(use_with X x11) $(use_with sidplay) $(use_with alsa) $(use_with flac)
}

src_compile() {
	emake 
}

src_install() {
	emake DESTDIR=${D} install || die
	cp ../CP* /${D}/usr/share/${P}/data
}