# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 git-r3

DESCRIPTION="System monitor extension for GNOME Shell"
HOMEPAGE="https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet"
SRC_URI=""
EGIT_REPO_URI="https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.26
	>=gnome-base/gnome-desktop-3.10:3
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
}

src_configure() {
	default
}

src_install() {
	default

	local extension="/usr/share/gnome-shell/extensions/system-monitor@paradoxxx.zero.gmail.com"
	local schemas="/usr/share/glib-2.0/schemas"

	# Create shemas directory tree in image and move schema
	insinto "${schemas}"
	mv \
		"${ED}${extension}/schemas/org.gnome.shell.extensions.system-monitor.gschema.xml" \
		"${ED}${schemas}"

	# Clean up
	rm -rf "${ED}${extension}/schemas"
	rm -rf "${ED}${extension}/README"
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
