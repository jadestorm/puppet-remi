# Define: remi::rpm_gpg_key
# ===========================
#
# Import a RPM GPG key for the Remi.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `ensure`
# Whether the named file should exist.
#
# * `path`
# The path to the name file to manage. Must be an absolute path.  Defaults to $name.
#
define remi::rpm_gpg_key (
  $ensure = present,
  $path   = $name,
  $source = 'puppet:///modules/remi/RPM-GPG-KEY-remi',
){

  file { $path:
    ensure => $ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => $source,
    before => Exec["import-remi-${name}"],
  }

  exec { "import-remi-${name}":
    command => "rpm --import ${path}",
    path    => ['/bin', '/usr/bin'],
    unless  => "rpm -q gpg-pubkey-$(echo $(gpg -q --throw-keyids --keyid-format short < ${path}) | grep pub | cut -f2 -d/ | cut -f1 -d' ' | tr '[A-Z]' '[a-z]')",
  }

}
