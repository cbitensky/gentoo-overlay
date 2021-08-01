# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A fast, simple and lightweight Lisp programming system"
HOMEPAGE="https://picolisp.com/"
LICENSE="MIT"

inherit bash-completion-r1

HOST="https://software-lab.de/"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="${HOST}picoLisp-${PV}.tgz"
	KEYWORDS="~amd64"
fi

SLOT="0"
IUSE="bash-completion doc ipv6 source ssl"
LANGS="ca de el en es fr ja no ru sv uk"
for L in ${LANGS}; do
	IUSE+=" l10n_${L}"
done

RDEPEND="
	sys-libs/readline
	dev-libs/libffi
	ssl? ( dev-libs/openssl )
	bash-completion? ( app-shells/bash-completion )
"

DEPEND="
	${RDEPEND}
	sys-devel/clang
"

src_unpack() {

	default

	NAME=pil21

	if [[ ${PV} == 9999 ]]; then
		wget "${HOST}${NAME}.tgz" || die
		tar xf *.tgz || die
	fi

	S="${WORKDIR}/${NAME}"

}

src_prepare() {

	# Because of /usr/lib* is for platform specific files,
	# move all but binaries to /usr/share

	# Move all from bin/, because bin/ will used for built binaries
	mkdir sharebin
	mv bin/* sharebin/

	# Remove .SILENT pseudo-target
	# We don’t need pic model
	# Make new variable for optimization flags
	sed -i '
		/\.SILENT:/d
		s/ -O3/ \$(OPTFLAGS)/
		/^CC\s*=/a OPTFLAGS ?= -O3\nCLANGFLAGS ?= \$(OPTFLAGS)
		s/\$(CC) \$(OPTFLAGS) / \$(_TEMP_CC) /
		s/\$(CC)/\$(CC) \$(CLANGFLAGS)/
		s/\$(_TEMP_CC)/\$(CC) \$(OPTFLAGS)/
		s/ picolisp.bc -relocation-model=pic/ picolisp.bc/
		' src/Makefile || die

	# We are not OpenBSD
	sed -i '/OpenBSD/,+6d' lib/net.l || die

	# Replace all references from /usr/lib to /usr/share
	grep -lFR /usr/lib/ . | xargs sed -i "s#/usr/lib/#/usr/share/#g"

	# Patch source code to be able to run on ipv4-only kernel
	if use !ipv6; then
		sed -i '
			s/INET6/INET/g
			s/SIN6/SIN/g
			s/sin6/sin/g
			s/sockaddr_in6/sockaddr_in/g
			s/sin_addr = in6addr_any/sin_addr.s_addr = INADDR_ANY/g
			s/sin_addr = in6addr_loopback/sin_addr.s_addr = htonl(INADDR_LOOPBACK)/
			s/(struct (+ Addr sin_addr) NIL (0 \. 8) (0 \. 8))/(struct (+ Addr sin_addr) NIL (0 \. 4))/
			' lib/net.l src/sysdefs.c src/httpGate.c
	fi

	default
}

src_compile() {

	cd src
	local BIN=../bin LIB=../lib
	use ssl && local SSL="${BIN}/balance ${BIN}/ssl ${BIN}/httpGate"

	# We need make base.ll up-to-date if we used patches
	# Bootstrapping
	touch base.ll
	emake ${BIN}/picolisp

	# Building real picolisp
	touch main.l
	emake ${LIB}/sysdefs
	emake ${BIN}/picolisp ${LIB}/ext.so ${LIB}/ht.so ${SSL}
}

src_install() {

	# We are not Android
	rm lib/android.l

	# Remove unused loc/* files
	declare -A LFILES=(\
		[ca]="ca ES.l"\
		[de]="de DE.l CH.l"\
		[el]="el GR.l"\
		[en]="GB.l US.l"\
		[es]="es ES.l AR.l"\
		[fr]="fr FR.l"\
		[ja]="ja JP.l"\
		[no]="no NO.l"\
		[ru]="ru RU.l"\
		[sv]="sv SE.l"\
		[uk]="uk UA.l"\
	)

	KEEPFILES="NIL.l"
	for L in ${LANGS}; do
		if use l10n_${L}; then
			KEEPFILES+=" ""${LFILES[$L]}"
		fi
	done

	mv loc oldloc
	mkdir loc
	cd oldloc
	mv $KEEPFILES ../loc/
	cd -

	for F in bin/picolisp sharebin/pil; do
		dobin "${F}"
		rm "${F}"
	done

	LIBDIR="$(get_libdir)"
	LIB="/usr/${LIBDIR}/${PN}"
	SHARE="/usr/share/${PN}"

	# Install all +x scripts to /usr/share/picolisp/bin
	exeinto ${SHARE}/bin
	doexe sharebin/*

	if use ssl; then
		# Install all binaries to /usr/lib*/picolisp/
		# and make symlinks to them in /usr/share/picolisp/bin/
		exeinto "/usr/libexec/${PN}"
		cd bin
		for F in *; do
			doexe "${F}"
			dosym "../../../libexec/${PN}/${F}" "${SHARE}/bin/${F}"
		done
		cd -
	fi

	# “ext.so” and “ht.so” are shared libraries used by standard library.
	# Move them to /usr/lib*/picolisp and make symlinks to them in /usr/share/picolisp/lib/
	insinto ${LIB}
	cd lib
	for N in ext ht; do
		F="${N}.so"
		doins "${F}"
		rm "${F}"
		dosym "../../../${LIBDIR}/${PN}/${F}" "${SHARE}/lib/${F}"
	done
	cd -

	doman man/*/*

	if use bash-completion; then
		newbashcomp lib/bash_completion "${PN}"
		bashcomp_alias "${PN}" pil
	else
		# this file used only for bash completion
		rm lib/complete.l
	fi
	rm lib/bash_completion

	# This is main install routine
	insinto "${SHARE}"
	doins -r *.l *.css img lib loc

	dodoc doc/ChangeLog COPYING INSTALL README

	if use doc; then
		mkdir docs
		rm doc/ChangeLog
		mv doc/{diff,structures} docs
		DOCS=docs/*
		HTML_DOCS=doc/*
		einstalldocs
		dosym "../doc/${PF}/html" "${SHARE}/doc"
	fi

	if use source; then
		cd src
		emake clean
		rm Makefile
		insinto "/usr/src/${PN}"
		doins -r *
	fi

}
