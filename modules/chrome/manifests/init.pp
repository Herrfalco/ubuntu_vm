# modules/chrome/manifests/init.pp
class chrome (
  String $repo_file = '/etc/apt/sources.list.d/google-chrome.list',
  String $keyring   = '/usr/share/keyrings/google-linux-signing.gpg',
  String $key_url   = 'https://dl.google.com/linux/linux_signing_key.pub',
) {

  # Pré-requis (HTTPS + gpg)
  package { ['ca-certificates', 'wget', 'gnupg']:
    ensure => installed,
  }

  # Clé GPG (idempotent grâce à creates)
  exec { 'google-chrome-gpg':
    command => "/usr/bin/wget -qO- ${key_url} | /usr/bin/gpg --dearmor -o ${keyring}.tmp && /bin/chmod 0644 ${keyring}.tmp && /bin/mv ${keyring}.tmp ${keyring}",
    path    => ['/bin','/usr/bin'],
    creates => $keyring,
    require => Package['wget','gnupg','ca-certificates'],
  }

  # Dépôt APT signé par la clé locale (idempotent via File)
  file { $repo_file:
    ensure  => file,
    mode    => '0644',
    content => "deb [arch=amd64 signed-by=${keyring}] https://dl.google.com/linux/chrome/deb/ stable main\n",
    notify  => Exec['apt-update'],
    require => Exec['google-chrome-gpg'],
  }

  # apt-get update seulement si le dépôt change
  exec { 'apt-update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
  }

  # Paquet Chrome (idempotent)
  package { 'google-chrome-stable':
    ensure  => installed,      # ou 'latest' si tu veux auto-MAJ
    require => File[$repo_file],
  }
}
