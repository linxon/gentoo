# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=FONKIE
MODULE_VERSION=2.28
inherit perl-module

DESCRIPTION="Read the CDDB entry for an audio CD in your drive"
HOMEPAGE="http://armin.emx.at/cddb/ https://metacpan.org/release/CDDB_get"

LICENSE="|| ( Artistic GPL-2 )" # "as perl, either GPL-2 or Artistic"
SLOT="2"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE=""

SRC_TEST=do
