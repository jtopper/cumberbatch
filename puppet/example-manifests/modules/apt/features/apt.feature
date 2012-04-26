Feature: APT configuration
    In order to use package repositories
    As a systems administrator
    I want to configure apt for use

    Scenario: Base repository configuration
        Given there is a running VM called "server"
        When I apply a puppet manifest containing:
        """
        class { apt: }
        """
	Then a second manifest application should do nothing

    Scenario: Base repository configuration with proxy
        Given there is a running VM called "server"
        When I apply a puppet manifest containing:
        """
        class { apt:
            proxy => "http://localhost:3128"
        }
        """
        Then a second manifest application should do nothing

        And there should be a file called /etc/apt/apt.conf.d/02proxy
