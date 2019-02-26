# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 gnome2

DESCRIPTION="Moves legacy tray icons to top panel"
HOMEPAGE="https://extensions.gnome.org/extension/1031/topicons/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/phocean/TopIcons-plus"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	app-eselect/eselect-gnome-shell-extensions
	dev-libs/glib:2
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-shell-3.16
"
DEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
}

src_configure() {
	default
}

src_compile() {
	:
}

src_install() {
	local extension="/usr/share/gnome-shell/extensions/TopIcons@phocean.net"
	local schemas="/usr/share/glib-2.0/schemas"

	insinto "${extension}"
	doins *.js metadata.json
	doins -r locale
	dodoc README.md

	insinto "${schemas}"
	doins schemas/*.gschema.xml

	rm "${ED}${extension}"/locale/*/LC_MESSAGES/*.po || die
}

pkg_postinst() {
	gnome2_pkg_postinst

	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update || die
	elog
	elog "Installed extensions are initially disabled by default."
	elog "To change the system default and enable some extensions, you can use"
	elog "# eselect gnome-shell-extensions"
	elog "Alternatively, you can use the org.gnome.shell disabled-extensions"
	elog "gsettings key to change the disabled extension list per-user."
	elog
}
