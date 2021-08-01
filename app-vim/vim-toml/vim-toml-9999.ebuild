# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/cespare/vim-toml.git"
	inherit git-r3
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI="https://github.com/"
fi

DESCRIPTION="vim plugin: syntax for TOML"
HOMEPAGE="https://github.com/cespare/vim-toml"
LICENSE="MIT"

DEPEND="|| ( app-editors/vim app-editors/gvim app-editors/neovim )"
RDEPEND="${DEPEND}"
SLOT=0

src_install() {

	for f in *; do
		[[ -f "${f}" ]] || continue
		dodoc "${f}"
		rm "${f}" || die
	done
	DIR=$D/usr/share/vim/vimfiles/pack/plugins/start/${PN}
	mkdir -p $DIR
	mv * $DIR || die

}
