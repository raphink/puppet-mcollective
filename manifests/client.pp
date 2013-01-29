class mcollective::client (
  $security_provider = 'psk',
  $security_secret = $::mcollective_psk,
  $connector = 'rabbitmq',
  $vhost = '/mcollective',
  $host = $::stomp_broker,
  $port = $::stomp_port,
  $user = 'guest',
  $password = 'guest',
  $ssl = true,
  $ssl_cert = "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  $ssl_key = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
  $ssl_ca = '/var/lib/puppet/ssl/certs/ca.pem',
) {

  $client_require = $::operatingsystem ? {
    /Debian|Ubuntu/ => [Package['rubygems'], Package['ruby-stomp']],
    /RedHat|CentOS/ => [Package['rubygems'], Package['rubygem-stomp']],
  }

  package { 'mcollective-client':
    ensure  => present,
    require => $client_require,
  }

  $mcollective_libdir = $::operatingsystem ? {
    /Debian|Ubuntu/ => '/usr/share/mcollective/plugins',
    /RedHat|CentOS/ => '/usr/libexec/mcollective',
  }

  file { '/etc/mcollective/client.cfg':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('mcollective/client.cfg.erb'),
    require => Package['mcollective'],
  }

  file { '/etc/bash_completion.d/mco':
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/mcollective/bash_completion.sh',
  }
}
