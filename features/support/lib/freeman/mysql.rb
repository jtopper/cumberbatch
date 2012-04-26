module Freeman

    class Mysql

        def can_connect(username,password)

            `mysqladmin -u "#{username}" -p"#{password}" status 2>&1 >/dev/null`
            if( ! $?.success? )
                return {
                    'code' => 1,
                    'text' => 'mysqladmin command failed with given credentials'
                }
            end

            return {
                'code' => 0,
                'text' => 'mysqladmin command succeeded with given credentials'
            }

        end

        def variables

            # Default is to use an anonymous user
            mysqladmin_command = "mysqladmin variables -u anon_cucumber"

            # If we're on debian, we probably want to use the debian defaults
            if FileTest.exists?( '/etc/mysql/debian.cnf' )
                mysqladmin_command = "mysqladmin --defaults-file=/etc/mysql/debian.cnf variables"
            end

            variables = {}

            IO.popen( mysqladmin_command ) { |mysqladmin|
                mysqladmin.each { |line|
                    if line =~ /^\| (\S+)\s+\| (\S+)\s+\|$/

                        variable = Regexp.last_match(1)
                        value    = Regexp.last_match(2)

                        variables[variable] = value
                    end
                }
            }

            return variables

        end

    end

end
