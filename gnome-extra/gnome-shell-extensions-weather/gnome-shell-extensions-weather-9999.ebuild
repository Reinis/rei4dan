# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 gnome2

DESCRIPTION="Weather applet extension for GNOME Shell"
HOMEPAGE="https://github.com/Neroth/gnome-shell-extension-weather"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Neroth/gnome-shell-extension-weather"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS=""

COMMON_DEPEND="
	>=dev-libs/glib-2.26
	>=gnome-base/gnome-desktop-3:3
	app-eselect/eselect-gnome-shell-extensions"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-desktop:3[introspection]
	gnome-base/gnome-shell
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.26
	gnome-base/gnome-common"

src_prepare() {
	default
	./autogen.sh
}

pkg_postinst() {
	gnome2_pkg_postinst

	einfo "Updating list of installed extensions"
	eselect gnome-shell-extensions update || die
	elog
	elog "Installed extensions installed are initially disabled by default."
	elog "To change the system default and enable some extensions, you can use"
	elog "# eselect gnome-shell-extensions"
	elog "Alternatively, you can use the org.gnome.shell disabled-extensions"
	elog "gsettings key to change the disabled extension list per-user."
	elog
}
