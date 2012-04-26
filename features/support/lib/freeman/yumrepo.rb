
module Freeman

    class Yumrepo


        @yum_inifile = nil

        def repo_configured_and_enabled(repo)

            # I really dislike having to put these requires in
            #  each method, but for some reason cucumber 
            #  tries to pull in these libraries when it starts up,
            #  and puppet only needs to be available in the guest so
            #  this fails.  It's some kind of automated file traversal
            #  by the looks of things, and we could get around this by 
            #  taking Freeman completely out of the features/ tree

            require 'puppet'

            @yum_inifile ||= Puppet::Type.type(:yumrepo).read
            yum_inifile = @yum_inifile

            if( yum_inifile[repo].nil? ) 
                return {
                    'code' => 1,
                    'text' => "Repo '#{repo}' doesn't exist in the yum config"
                }
            end

            if( yum_inifile[repo]['enabled'] != "1" ) 
                return {
                    'code' => 2,
                    'text' => "Repo #{repo} exists but is not enabled"
                }
            end

            return {
                'code' => 0,
                'text' => "OK"
            }

        end

        def repo_uses_gpg(repo)

            require 'puppet'

            @yum_inifile ||= Puppet::Type.type(:yumrepo).read
            yum_inifile = @yum_inifile

            if( yum_inifile[repo].nil? ) 
                return {
                    'code' => 1,
                    'text' => "Repo '#{repo}' doesn't exist in the yum config"
                }
            end

            if( yum_inifile[repo]['gpgcheck'] != "1" )
                return {
                    'code' => 2,
                    'text' => "Repo '#{repo}' doesn't use GPG"
                }
            end

            return {
                'code' => 0,
                'text' => 'OK',
            }

        end

        def repo_uses_proxy(repo,proxy)

            @yum_inifile ||= Puppet::Type.type(:yumrepo).read
            yum_inifile = @yum_inifile

            if( yum_inifile[repo].nil? ) 
                return {
                    'code' => 1,
                    'text' => "Repo '#{repo}' doesn't exist in the yum config"
                }
            end

            if( yum_inifile[repo]['proxy'] == proxy )
                return {
                    'code' => 0,
                    'text' => 'OK'
                }
            end

            return {
                'code' => 2,
                'text' => "Proxy was #{yum_inifile[repo]['proxy']} - expected #{proxy}"
            }

        end

        def repo_gpg_key_exists(repo)

            require 'puppet'

            @yum_inifile ||= Puppet::Type.type(:yumrepo).read
            yum_inifile = @yum_inifile

            if( yum_inifile[repo].nil? ) 
                return {
                    'code' => 1,
                    'text' => "Repo '#{repo}' doesn't exist in the yum config"
                }
            end

            key_file = yum_inifile[repo]['gpgkey'].gsub(/^file:\/\//, '')

            if( ! FileTest.exists?( key_file ) )
                return {
                    'code' => 2,
                    'text' => "GPG key file #{key_file} doesn't exist for repo #{repo}"
                }
            end

            return {
                'code' => 0,
                'text' => 'OK',
            }
        end

    end

end
