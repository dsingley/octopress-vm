exec { 'aptitude-update' :
  command => '/usr/bin/aptitude update',
  logoutput => 'on_failure',
}

Package {
  provider => 'aptitude',
  require => Exec['aptitude-update'],
}

package { 'build-essential' :
  ensure => present,
}

package { 'git' :
  ensure => present,
}

file { '/home/vagrant/.ssh/config' :
  content => "IdentityFile /home/vagrant/dot-ssh/id_rsa",
}

file { '/etc/localtime' :
  ensure => 'link',
  target => '/usr/share/zoneinfo/America/New_York',
}

$ruby_version = '1.9.3-p194'

exec { 'install-ruby' :
  command => "/usr/bin/sudo -H -u vagrant /vagrant/manifests/install_ruby.sh ${ruby_version}",
  timeout => 600,
  unless => "/usr/bin/sudo -H -u vagrant -i rbenv versions | /bin/grep ${ruby_version}",
  logoutput => true,
  require => Package['git'],
}

