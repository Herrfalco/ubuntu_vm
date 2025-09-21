node default {
  include chrome

  $user = 'herrfalco'
  $home = "/home/${user}"

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
  ]:
    ensure => installed,
  }

  package {[
    'vim',
  ]:
    ensure => absent,
  }

  group { 'sudo':
    ensure  => present,
  }

  user { "${user}":
    ensure     => present,
    home       => $home,
    managehome => true,
    shell      => '/bin/bash',
    groups     => ['sudo'],
    password   => '$6$vvhbG4aduxlMg1K6$oC5OVpUuLk6ym3pcCZfOdRwr1ot83hmWeNq7RJ.exAh/73SYT44yF8Fd.ENt7Uj90VFUD5/BiAb1anfRnLyUX1',
  }

  exec { 'install_rustup':
    command     => "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y",
    user        => $user,
    environment => ["HOME=${home}"],
    creates     => "${home}/.cargo/bin/rustup",
    path        => ['/usr/bin', '/bin'],
    require     => [
      User[$user],
      Package['curl'],
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
  ]:
    ensure  => directory,
    owner   => $user,
    group  => $user,
    mode    => '0700',
    require => User[$user],
  }

  exec { 'install_tinymist':
    command     => "/usr/bin/curl --proto '=https' --tlsv1.2 -sSf https://github.com/Myriad-Dreamin/tinymist/releases/download/v0.13.26/tinymist-installer.sh | sh -s -- -y",
    user        => $user,
    environment => ["HOME=${home}"],
    creates     => "${home}/.local/bin/tinymist",
    path        => ['/usr/bin', '/bin'],
    require     => [
      File["${home}/.local/bin"],
      Package['curl'],
    ]
  }

  file { "${home}/.gnome_term_gruvbox.sh":
    ensure => file,
    owner  => $user,
    group   => $user,
    mode    => '0700',
    source  => '/vagrant/files/gnome_term_gruvbox.sh',
    require => User[$user],
  }

  file { "$home/.xinitrc":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0600',
    source => '/vagrant/files/xinitrc',
    require => User[$user],
  }

  file { "${home}/.config/i3/config":
    ensure  => file,
    owner   => $user,
    group  => $user,
    mode    => '0600',
    source  => '/vagrant/files/i3.conf',
    require => File["${home}/.config/i3"],
  }

  file { "${home}/Images/wallpaper.jpg":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0600',
    source  => '/vagrant/files/wallpaper.jpg',
    require => File["${home}/Images"],
  }

  file { "${home}/.Xresources":
    ensure  =>  file,
    owner   => $user,
    group   => $user,
    mode    => '0600',
    source  => '/vagrant/files/Xresources.conf',
    require => User[$user],
  }

  file { "${home}/.xrandr-setup.sh":
    ensure => file,
    owner  => $user,
    group   => $user,
    mode    => '0700',
    source  => '/vagrant/files/xrandr-setup.sh',
    require => User[$user],
  }

  file { "${home}/.vimrc":
    ensure => file,
    owner  => $user,
    group   => $user,
    mode    => '0600',
    source  => '/vagrant/files/vimrc',
    require => User[$user],
  }
}
