TERMUX_PKG_HOMEPAGE=https://ffmpeg.org
TERMUX_PKG_DESCRIPTION="Tools and libraries to manipulate a wide range of multimedia formats and protocols"
TERMUX_PKG_LICENSE="GPL-3.0"
# NOTE: mpv has to be rebuilt and version bumped after updating ffmpeg.
TERMUX_PKG_VERSION=4.1.3
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://www.ffmpeg.org/releases/ffmpeg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0c3020452880581a8face91595b239198078645e7d7184273b8bcc7758beb63d
TERMUX_PKG_DEPENDS="libass, libbz2, libiconv, libsoxr, libx264, libx265, xvidcore, libvorbis, libmp3lame, libopus, libvpx, libgnutls, libandroid-glob, freetype, zlib, liblzma"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="share/ffmpeg/examples"
TERMUX_PKG_CONFLICTS="libav"

termux_step_configure() {
	cd $TERMUX_PKG_BUILDDIR

	export ASFLAGS="-no-integrated-as"

	local _EXTRA_CONFIGURE_FLAGS=""
	if [ $TERMUX_ARCH = "arm" ]; then
		_ARCH="armeabi-v7a"
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	elif [ $TERMUX_ARCH = "i686" ]; then
		_ARCH="x86"
		# Specify --disable-asm to prevent text relocations on i686,
		# see https://trac.ffmpeg.org/ticket/4928
		_EXTRA_CONFIGURE_FLAGS="--disable-asm"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		_ARCH="x86_64"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		_ARCH=$TERMUX_ARCH
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	$TERMUX_PKG_SRCDIR/configure \
		--arch=${_ARCH} \
		--as=$AS \
		--cc=$CC \
		--cxx=$CXX \
		--cross-prefix=${TERMUX_HOST_PLATFORM}- \
		--disable-indevs \
		--disable-outdevs \
		--enable-indev=lavfi \
		--disable-static \
		--disable-symver \
		--enable-cross-compile \
		--enable-gnutls \
		--enable-gpl \
		--enable-libass \
		--enable-libmp3lame \
		--enable-libfreetype \
		--enable-libvorbis \
		--enable-libopus \
		--enable-libx264 \
		--enable-libx265 \
		--enable-libxvid \
		--enable-libvpx \
		--enable-shared \
		--enable-libsoxr \
		--prefix=$TERMUX_PREFIX \
		--target-os=android \
		--extra-libs="-landroid-glob" \
		$_EXTRA_CONFIGURE_FLAGS
}

