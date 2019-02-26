# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 gnome2

DESCRIPTION="Add hibernate/hybrid suspend button in Gnome Shell status menu"
HOMEPAGE="https://github.com/arelange/gnome-shell-extension-hibernate-status"
SRC_URI=""
EGIT_REPO_URI="https://github.com/arelange/gnome-shell-extension-hibernate-status"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.26
	>=gnome-base/gnome-desktop-3.14:3
	app-eselect/eselect-gnome-shell-extensions"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-desktop:3[introspection]
	gnome-base/gnome-shell
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
	gnome-base/gnome-common"

src_prepare() {
	default
}

src_configure() {
	default
}

src_install() {
	default

	insinto "/usr/share/gnome-shell/extensions/hibernate-status@dromi"
	doins confirmDialog.js extension.js metadata.json
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
