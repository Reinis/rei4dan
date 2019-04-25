# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils git-r3 readme.gentoo-r1

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
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-desktop:3[introspection]
	gnome-base/gnome-shell
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
"
DEPEND="${COMMON_DEPEND}
	gnome-base/gnome-common
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.26
"

DOC_CONTENTS="The installed extensions are initially disabled by default.\n
To change the system default and enable some extensions, you can use\n
# eselect gnome-shell-extensions\n
Alternatively, you can use the org.gnome.shell disabled-extensions\n
gsettings key to change the disabled extension list per-user."

MAKEOPTS="${MAKEOPTS} V=1"

src_prepare() {
	default
	sed -i -e 's%$(DESTDIR)usr%$(DESTDIR)/usr%' "${S}/Makefile" || die "DESTDIR fix failed"
	sed -i -e 's/SUDO=sudo/SUDO=/' "${S}/Makefile" || die "Removing sudo failed"
	sed -i -e '/ -s reload/d' "${S}/Makefile" || die "Removing reload failed"
	sed -i -e '/schemas\/gschemas.compiled _build\/schemas\//d' "${S}/Makefile" || die "Removing compiled copy failed"
}

src_configure() {
	default
}

src_compile() {
	:
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

	readme.gentoo_create_doc
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update

	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_schemas_update
}
