node default {
  include chrome

  $user = 'herrfalco'
  $ids = 2000
  $home = "/home/${user}"
  $shared = '/vagrant/files'
  $gruv_stamp = "${home}/.config/.gnome_gruvbox_configured"

  package {[
    'vim',
  ]:
    ensure => absent,
  }

  package {[
    'xserver-xorg',
    'xinit',
    'i3',
    'feh',
    'x11-xserver-utils',
    'spice-vdagent',
    'xclip',
    'dbus-x11',
    'mesa-utils',
    'gnome-terminal',
    'evince',
    'vim-gtk3',
    'nodejs',
    'npm',
    'curl',
    'dconf-cli',
    'libssl-dev',
    'pkg-config',
    'python3-autopep8',
  ]:
    ensure  => installed,
    require => Package['vim'],
  }

  group { 'sudo':
    ensure  => present,
  }

  group { 'herrfalco':
    ensure => present,
    gid    => $ids,
  }

  user { "${user}":
    ensure     => present,
    home       => $home,
    managehome => true,
    shell      => '/bin/bash',
    groups     => ['sudo'],
    uid        => $ids,
    gid        => 'herrfalco',
    password   => '$6$vvhbG4aduxlMg1K6$oC5OVpUuLk6ym3pcCZfOdRwr1ot83hmWeNq7RJ.exAh/73SYT44yF8Fd.ENt7Uj90VFUD5/BiAb1anfRnLyUX1',
    require    => [
      Group['sudo'],
      Group['herrfalco'],
    ]
  }

  file {[
    "${home}/Work",
    "${home}/Images",
    "${home}/Downloads",
    "${home}/.config",
    "${home}/.config/i3",
    "${home}/.local",
    "${home}/.local/bin",
    "${home}/.local/share",
    "${home}/.scripts",
    "${home}/.vim",
  ]:
    ensure  => directory,
    owner   => $user,
    group  => $user,
    mode    => '0700',
    require => User[$user],
  }

################ Config Files #########################

  file { "${home}/.xinitrc":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0600',
    source  => "${shared}/xinitrc",
    require => User[$user],
  }

  file { "${home}/.config/i3/config":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0600',
    source  => "${shared}/i3.conf",
    require => File["${home}/.config/i3"],
  }

  file { "${home}/.vimrc":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0600',
    source  => "${shared}/vimrc",
    require => User[$user],
  }

  file { "${home}/.vim/coc-settings.json":
    ensure  => file,
    owner   => $user,
    mode    => '0666',
    source  => "${shared}/coc-settings.json",
    require => Package['vim-gtk3'],
  }

################ Installation Scripts ####################

  exec { 'install_rustup':
    command     => "${shared}/install_rustup.sh",
    user        => $user,
    creates     => "${home}/.cargo/bin/rustup",
    require     => [
      User[$user],
      Package['curl'],
    ],
  }

  exec { 'install_typst':
    command => "${shared}/install_typst.sh",
    user    => $user,
    path    => [
      "${home}/.cargo/bin",
      "/usr/bin",
    ],
    creates => "${home}/.cargo/bin/typst",
    require => [
      Package['libssl-dev'],
      Package['pkg-config'],
      Exec['install_rustup'],
    ]
  }

  exec { 'install_tinymist':
    command     => "${shared}/install_tinymist.sh",
    user        => $user,
    creates     => "${home}/.local/bin/tinymist",
    require     => [
      File["${home}/.local/bin"],
      Package['curl'],
    ],
  }

  exec { 'config_gnome_gruvbox':
    command     => "${shared}/gnome_term_gruvbox.sh --dark",
    user        => $user,
    environment => "STAMP=${gruv_stamp}",
    creates     => $gruv_stamp,
    logoutput   => true,
    require     => File["${home}/.config"],
  }
}
