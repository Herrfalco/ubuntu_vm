node default {
  include chrome

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

  user { 'herrfalco':
    ensure     => present,
    home       => '/home/herrfalco',
    managehome => true,
    shell      => '/bin/bash',
    groups     => ['sudo'],
    password   => '$6$vvhbG4aduxlMg1K6$oC5OVpUuLk6ym3pcCZfOdRwr1ot83hmWeNq7RJ.exAh/73SYT44yF8Fd.ENt7Uj90VFUD5/BiAb1anfRnLyUX1',
  }

  file {[
    '/home/herrfalco/Work',
    '/home/herrfalco/Images',
    '/home/herrfalco/Downloads',
    '/home/herrfalco/.config',
    '/home/herrfalco/.config/i3',
  ]:
    ensure  => directory,
    owner   => 'herrfalco',
    group  => 'herrfalco',
    mode    => '0700',
    require => User['herrfalco'],
  }

  file { '/home/herrfalco/.xinitrc':
    ensure  => file,
    owner   => 'herrfalco',
    group   => 'herrfalco',
    mode    => '0600',
    source => '/vagrant/files/xinitrc',
    require => User['herrfalco'],
  }

  file { '/home/herrfalco/.config/i3/config':
    ensure  => file,
    owner   => 'herrfalco',
    group  => 'herrfalco',
    mode    => '0600',
    source  => '/vagrant/files/i3.conf',
    require => File['/home/herrfalco/.config/i3'],
  }

  file { '/home/herrfalco/Images/wallpaper.jpg':
    ensure  => file,
    owner   => 'herrfalco',
    group   => 'herrfalco',
    mode    => '0600',
    source  => '/vagrant/files/wallpaper.jpg',
    require => File['/home/herrfalco/Images'],
  }

  file { '/home/herrfalco/.Xresources':
    ensure  =>  file,
    owner   => 'herrfalco',
    group   => 'herrfalco',
    mode    => '0600',
    source  => '/vagrant/files/Xresources.conf',
    require => User['herrfalco'],
  }

  file { '/home/herrfalco/.xrandr-setup.sh':
    ensure => file,
    owner  => 'herrfalco',
    group   => 'herrfalco',
    mode    => '0700',
    source  => '/vagrant/files/xrandr-setup.sh',
    require => User['herrfalco'],
  }

  file { '/home/herrfalco/.gnome_term_gruvbox.sh':
    ensure => file,
    owner  => 'herrfalco',
    group   => 'herrfalco',
    mode    => '0700',
    source  => '/vagrant/files/gnome_term_gruvbox.sh',
    require => User['herrfalco'],
  }

  file { '/home/herrfalco/.vimrc':
    ensure => file,
    owner  => 'herrfalco',
    group   => 'herrfalco',
    mode    => '0600',
    source  => '/vagrant/files/vimrc',
    require => User['herrfalco'],
  }
}
