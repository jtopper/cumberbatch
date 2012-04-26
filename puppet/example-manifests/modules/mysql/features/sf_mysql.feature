Feature: MySQL installation
    In order to use the MySQL database
    As a systems administrator
    I want to install, configure and run mysql

    Scenario: Basical install of MySQL
        Given there is a running VM called "server"
        When I apply a puppet manifest containing:
            """
            include cumberbatch_defaults

            class { mysql:
                root_password => 'testpass'
            }
            """
        Then a second manifest application should do nothing

        And there should be a file called /var/lib/mysql/ibdata1
        And there should be a process matching /^mysqld$/ running
        And a process matching ^mysqld$ should be listening on TCP port 3306
        And I should be able to connect to mysql with username "root" and password "testpass"
        And the mysql variable "datadir" should be "/var/lib/mysql/"

    @current
    Scenario: Modification of MySQL config
        Given there is a running VM called "server"
        When I apply a puppet manifest containing:
            """
            include cumberbatch_defaults

            class { mysql:

                root_password => 'testpass',

                mysql_config => {
                    max_connections  => 1337
                }
            }
            """
        Then a second manifest application should do nothing
        And the mysql variable "max_connections" should be "1337"
