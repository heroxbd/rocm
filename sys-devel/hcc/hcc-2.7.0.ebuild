# Copyright
#

EAPI=7
inherit git-r3 cmake-utils flag-o-matic

DESCRIPTION="HCC - An open source C++ compiler for heterogeneous devices"
HOMEPAGE="https://github.com/RadeonOpenCompute/hcc"

EGIT_REPO_URI="https://github.com/RadeonOpenCompute/hcc.git"
EGIT_BRANCH="clang_tot_upgrade"

LICENSE=""
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="**"
IUSE="debug"
CMAKE_BUILD_TYPE=Release

RDEPEND="=dev-libs/rocr-runtime-${PV}*
	 dev-util/rocminfo"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-vcs/git"

src_configure() {
	if ! use debug; then
		append-cflags "-DNDEBUG"
		append-cxxflags "-DNDEBUG"
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hcc/$(ver_cut 1-2)"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/hcc/$(ver_cut 1-2)/share/man"
	)

	cmake-utils_src_configure
}

src_install() {
	echo "HCC_HOME=/usr/lib/hcc/$(ver_cut 1-2)" > 99hcc || die
	echo "HSA_PATH=/opt/rocm" >> 99hcc || die
	echo "LDPATH=/usr/lib/hcc/$(ver_cut 1-2)/lib" >> 99hcc || die
	echo "ROOTPATH=/usr/lib/hcc/$(ver_cut 1-2)/bin" >> 99hcc || die
	doenvd 99hcc

	cmake-utils_src_install
}

pkg_postinst() {
        elog "HCC is marked depracated, see:"
        elog "https://github.com/RadeonOpenCompute/hcc#deprecation-notice"
}
