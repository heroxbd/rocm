# Copyright
#

EAPI=7

inherit git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/hipCUB.git"
EGIT_COMMIG="rocm-$(ver_cut 1-2)"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*
         =sci-libs/rocPRIM-${PV}*"
DEPEND="${RDPEND}
	dev-util/cmake"

src_configure() {
	mkdir -p "${WORKDIR}/build/"
	cd "${WORKDIR}/build/"

	export PATH=$PATH:/usr/lib/hcc/$(ver_cut 1-2)/bin
	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/
	export hip_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
	export HIP_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
	export CXX=/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc

	cmake -DHIP_PLATFORM=hcc -DHIP_ROOT_DIR=/usr/lib/hip/$(ver_cut 1-2)/ -Drocprim_DIR=/usr/rocprim -DBUILD_TEST=OFF -DCMAKE_INSTALL_PREFIX=/usr ${S}
}

src_compile() {
	cd "${WORKDIR}/build/"
	make VERBOSE=1
}

src_install() {
	cd "${WORKDIR}/build/"
	emake DESTDIR="${D}" install
}
