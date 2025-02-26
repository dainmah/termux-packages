TERMUX_PKG_HOMEPAGE=https://github.com/open-source-parsers/jsoncpp
TERMUX_PKG_DESCRIPTION="C++ library for interacting with JSON"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_SRCURL=https://github.com/open-source-parsers/jsoncpp/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bdd3ba9ed1f110b3eb57474d9094e90ab239b93b4803b4f9b1722c281e85a4ac
TERMUX_PKG_DEPENDS="libc++"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DJSONCPP_WITH_TESTS=OFF
-DCCACHE_FOUND=OFF
"

termux_step_pre_configure() {
	# The installation does not overwrite symlinks such as libjsoncpp.so.1,
	# so if rebuilding these are not detected as modified. Fix that:
	rm -f $TERMUX_PREFIX/lib/libjsoncpp.so*
}
