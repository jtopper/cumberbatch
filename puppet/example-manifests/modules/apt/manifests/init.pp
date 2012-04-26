
define apt::add_deb_source ( $uri, $distribution, $component ) {

    concat::fragment { "apt_source_${title}":
        target  => "/etc/apt/sources.list",
        content => inline_template( "deb <%= uri %> <%= distribution %> <% component.each do |c| -%><%= c %> <% end -%>\n\n")
    }
    
}

class apt ( $proxy = absent ) {

    if $proxy != absent {
        file { "/etc/apt/apt.conf.d/02proxy":
            content => "Acquire::http::proxy \"$proxy\";\n"
        }
    }

    include concat::setup

    concat { "/etc/apt/sources.list":
        owner => root,
        group => root,
        mode  => 644
    }

    file { "/etc/pki/":
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 600
    }

    file { "/etc/pki/apt-gpg":
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => 600,
        require => File["/etc/pki"]
    }

    file { "/etc/pki/apt-gpg/percona-key-CD2EFD2A.gpg":
        source => "puppet:///modules/apt/keys/percona-key-CD2EFD2A.gpg"
    }

    exec { "import percona key":
        command     => "apt-key add /etc/pki/apt-gpg/percona-key-CD2EFD2A.gpg",
        refreshonly => true,
        subscribe   => File["/etc/pki/apt-gpg/percona-key-CD2EFD2A.gpg"],
        path        => "/bin:/usr/bin"
    }

    $archive_ubuntu_com = "http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/"

    apt::add_deb_source { "${lsbdistcodename}":
        uri          => $archive_ubuntu_com,
        distribution => "${lsbdistcodename}",
        component    => [ "main", "restricted", "universe", "multiverse" ]
    }

    apt::add_deb_source { "${lsbdistcodename}-updates":
        uri          => $archive_ubuntu_com,
        distribution => "${lsbdistcodename}-updates",
        component    => [ "main", "restricted", "universe", "multiverse" ]
    }

    apt::add_deb_source { "${lsbdistcodename}-backports":
        uri          => $archive_ubuntu_com,
        distribution => "${lsbdistcodename}-backports",
        component    => [ "main", "restricted", "universe", "multiverse" ]
    }

    apt::add_deb_source { "${lsbdistcodename}-security":
        uri          => $archive_ubuntu_com,
        distribution => "${lsbdistcodename}-security",
        component    => [ "main", "restricted", "universe", "multiverse" ]
    }

    apt::add_deb_source { "percona-${lsbdistcodename}":
        uri          => "http://repo.percona.com/apt",
        distribution => "${lsbdistcodename}",
        component    => [ "main" ],
        require      => File["/etc/pki/apt-gpg/percona-key-CD2EFD2A.gpg"]
    }

    exec { "apt-update":
        command     => "/usr/bin/apt-get update",
        refreshonly => true,
        subscribe   => File["/etc/apt/sources.list"]
    }

    File["/etc/apt/sources.list"] -> Package <| |>


}
