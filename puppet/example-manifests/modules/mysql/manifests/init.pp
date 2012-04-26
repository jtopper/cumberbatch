
class mysql::common {

    # Defaults for all packages:
    Package {
        ensure => installed
    }

    package { "mysql-common": }

}

class mysql::client {

    Package {
        ensure  => installed,
        require => Class["mysql::common"]
    }

    package { "mysql-client": }
}

class mysql::server {

    Package {
        ensure  => installed,
        require => Class["mysql::common"]
    }

    package { "mysql-server": }
}


class mysql::service {

    # Defaults for all services:
    Service {
        require => Class["mysql::config"],
        ensure  => running,
        enable => true
    }

    # Specific services:
    service { "mysql":}

}

class mysql::config ( $mysql_config ) {

    $mysql_editable_config = [
        'max_connections',
        'max_allowed_packet',
        'thread_stack',
        'thread_cache_size',
        'query_cache_limit',
        'query_cache_size',
        'innodb_buffer_pool_size',
        'server-id',
        'bind-address',
        'datadir',
        'log-bin',
        'expire_logs_days',
        'max_binlog_size',
        'log-output',
        'log-error',
        'long_query_time',
        'slow_query_log',
        'slow_query_log_file',
        'general-log',
        'tmpdir',
    ]

    # Defaults for all files in here:
    File {
        require => Class["mysql::server"],
        notify  => Class["mysql::service"],
        owner   => root,
        group   => root,
        mode    => 644
    }

    # Specific files
    # (use content => template("mysql/<path>") to use templates from
    #  this module).

    file { "/etc/my.cnf":
        content => template("mysql/my.cnf")
    }

}

#
# Class: mysql
#
# mysql configures the MySQL database server.
#  We expect a mysql_config variable containing values
#  which will then be used to populate the template.
#

class mysql ( $mysql_config = {}, $root_password ) {

    class { 'mysql::config':
        mysql_config => $mysql_config
    }

    include mysql::common
    include mysql::client
    include mysql::server
    include mysql::service

    exec { 'Set MySQL root password':
        require    => [
            Class["mysql::service"],
            Class["mysql::client"]
        ],
        subscribe  => Service["mysql"],
        refreshonly=> true,
        unless     => "/usr/bin/mysqladmin -u root -p\"$root_password\" status",
        command    => "/usr/bin/mysqladmin -u root password \"$root_password\""
    }

}
