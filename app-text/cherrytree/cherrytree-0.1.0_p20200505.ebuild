# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )

HASH_COMMIT="26afcc6b27635d5b710c481daf9ae74c8ab20ea8" # 20200505

inherit cmake python-any-r1 xdg-utils

DESCRIPTION="A hierarchical note taking application (C++ version)"
HOMEPAGE="https://www.giuspen.com/cherrytree"
SRC_URI="https://github.com/giuspen/cherrytree/archive/${HASH_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls test"

RESTRICT="!test? ( test )"

RDEPEND="
	app-text/gspell
	dev-cpp/gtkmm:3.0
	dev-cpp/gtksourceviewmm:3.0
	dev-cpp/libxmlpp:2.6
	dev-cpp/pangomm
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2:2"
DEPEND="${RDEPEND}
	$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
	test? ( dev-util/cpputest )"

PATCHES=(
	# TODO: It's an alpha/future C++ version and tests is enabled by default
	# We need to check any changes of it in CMakeLists and remove this patch
	# before bump a new version
	#
	# Disable cpptest pkg checking if 'test' flag is inactive
	"${FILESDIR}/${P}_disable_tests_by_default.patch"
	"${FILESDIR}/${P}_disable_compress_man_pages.patch"
)

S="${WORKDIR}/${PN}-${HASH_COMMIT}/future"

python_check_deps() { has_version "dev-python/lxml[${PYTHON_USEDEP}]"; }
pkg_setup() { python_setup; }

src_prepare() {
	sed -i \
		-e "s|\(CT_VERSION.*{\)\(.*\)\(};\)$|\1\"${PV}\"\3|" \
		src/ct/ct_const.h || die

	python_fix_shebang "${S}/scripts"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=( -DUSE_CPPTEST=$(usex test) )
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
