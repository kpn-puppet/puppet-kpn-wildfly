require 'spec_helper_acceptance'

describe 'Do RedHat stuff' do
  if fact('osfamily') == 'RedHat'
    context 'default parameters' do
      # Using puppet_apply as a helper
      it 'is_expected.to work idempotently with no errors' do
        pp = <<-EOS
        package { 'java-1.8.0-openjdk':
          ensure => 'present',
        }
        # Install Wildfly 8
        wildfly::install { 'wildfly8':
          catalina_home => '/opt/wildfly8',
          source        => 'http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz'
          checksum      => '845bc298ef9d72cf91b8781286a64554dea353df9d555391720635f32b73717c',
        }
        wildfly::instance { 'wildfly8':
          catalina_home   => '/opt/wildfly8',
          manage_service  => true,
          port_properties => { 'management-http' => 19990, 'management-https' => 19993, 'ajp' => 18009, 'http' => 18080, 'https' => 18443, },
        }
        wildfly::config::module { 'org.postgresql:/opt/wildfly8':
          source       => 'https://jdbc.postgresql.org/download/postgresql-42.1.4.jar',
          checksum     => '4523ed32e9245e762e1df9f0942a147bece06561770a9195db093d9802297735',
          dependencies => ['javax.api', 'javax.transaction.api']
        }
        wildfly::datasources::driver { 'Driver postgresql:/opt/wildfly8':
          driver_name                     => 'postgresql',
          driver_module_name              => 'org.postgresql',
          driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource',
          port_properties                 => { 'management-http' => 19990, 'management-https' => 19993, 'ajp' => 18009, 'http' => 18080, 'https' => 18443, },
        }
        wildfly::datasources::datasource { 'DemoDS:/opt/wildfly8':
          config          => {
           'driver-name'    => 'postgresql',
           'connection-url' => 'jdbc:postgresql://localhost/postgres',
           'jndi-name'      => 'java:jboss/datasources/DemoDS',
          },
          port_properties => { 'management-http' => 19990, 'management-https' => 19993, 'ajp' => 18009, 'http' => 18080, 'https' => 18443, },
        }

        # Install Wildfly 9
        wildfly::install { 'wildfly9':
          catalina_home => '/opt/wildfly9',
          source        => 'http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz',
          checksum      => '74689569d6e04402abb7d94921c558940725d8065dce21a2d7194fa354249bb6',
        }
        wildfly::instance { 'wildfly9':
          catalina_home   => '/opt/wildfly9',
          manage_service  => true,
          port_properties => { 'management-http' => 29990, 'management-https' => 29993, 'ajp' => 28009, 'http' => 28080, 'https' => 28443, },
        }
        wildfly::config::module { 'org.postgresql:/opt/wildfly9':
          source       => 'https://jdbc.postgresql.org/download/postgresql-42.1.4.jar',
          checksum     => '4523ed32e9245e762e1df9f0942a147bece06561770a9195db093d9802297735',
          dependencies => ['javax.api', 'javax.transaction.api']
        }
        wildfly::datasources::driver { 'Driver postgresql:/opt/wildfly9':
          driver_name                     => 'postgresql',
          driver_module_name              => 'org.postgresql',
          driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource',
          port_properties                 => { 'management-http' => 29990, 'management-https' => 29993, 'ajp' => 28009, 'http' => 28080, 'https' => 28443, },
        }
        wildfly::datasources::datasource { 'DemoDS:/opt/wildfly9':
          config          => {
           'driver-name'    => 'postgresql',
           'connection-url' => 'jdbc:postgresql://localhost/postgres',
           'jndi-name'      => 'java:jboss/datasources/DemoDS',
          },
          port_properties => { 'management-http' => 29990, 'management-https' => 29993, 'ajp' => 28009, 'http' => 28080, 'https' => 28443, },
        }

        # Install Wildfly 10
        wildfly::install { 'wildfly10':
          catalina_home => '/opt/wildfly10',
          source        => 'http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.tar.gz',
          checksum      => '80781609be387045273f974662dadf7f64ad43ee93395871429bc6b7786ec8bc',
        }
        wildfly::instance { 'wildfly10':
          catalina_home   => '/opt/wildfly10',
          manage_service  => true,
          port_properties => { 'management-http' => 39990, 'management-https' => 39993, 'ajp' => 38009, 'http' => 38080, 'https' => 38443, },
        }
        wildfly::config::module { 'org.postgresql:/opt/wildfly10':
          source       => 'https://jdbc.postgresql.org/download/postgresql-42.1.4.jar',
          checksum     => '4523ed32e9245e762e1df9f0942a147bece06561770a9195db093d9802297735',
          dependencies => ['javax.api', 'javax.transaction.api']
        }
        wildfly::datasources::driver { 'Driver postgresql:/opt/wildfly10':
          driver_name                     => 'postgresql',
          driver_module_name              => 'org.postgresql',
          driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource',
          port_properties                 => { 'management-http' => 39990, 'management-https' => 39993, 'ajp' => 38009, 'http' => 38080, 'https' => 38443, },
        }
        wildfly::datasources::datasource { 'DemoDS:/opt/wildfly10':
          config          => {
           'driver-name'    => 'postgresql',
           'connection-url' => 'jdbc:postgresql://localhost/postgres',
           'jndi-name'      => 'java:jboss/datasources/DemoDS',
          },
          port_properties => { 'management-http' => 39990, 'management-https' => 39993, 'ajp' => 38009, 'http' => 38080, 'https' => 38443, },
        }

        # Install Wildfly 11
        wildfly::install { 'wildfly11':
          catalina_home => '/opt/wildfly11',
          source        => 'http://download.jboss.org/wildfly/11.0.0.Final/wildfly-11.0.0.Final.tar.gz',
          checksum      => 'a2f5fb4187369196003e31eb086f0a1f7bfc0645a3a61a53ed20ab5853481e71',
        }
        wildfly::instance { 'wildfly11':
          catalina_home   => '/opt/wildfly11',
          manage_service  => true,
          port_properties => { 'management-http' => 49990, 'management-https' => 49993, 'ajp' => 48009, 'http' => 48080, 'https' => 48443, },
        }
        wildfly::config::module { 'org.postgresql:/opt/wildfly11':
          source       => 'https://jdbc.postgresql.org/download/postgresql-42.1.4.jar'
          checksum     => '4523ed32e9245e762e1df9f0942a147bece06561770a9195db093d9802297735',
          dependencies => ['javax.api', 'javax.transaction.api']
        }
        wildfly::datasources::driver { 'Driver postgresql:/opt/wildfly11':
          driver_name                     => 'postgresql',
          driver_module_name              => 'org.postgresql',
          driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource',
          port_properties                 => { 'management-http' => 49990, 'management-https' => 49993, 'ajp' => 48009, 'http' => 48080, 'https' => 48443, },
        }
        wildfly::datasources::datasource { 'DemoDS:/opt/wildfly11':
          config          => {
           'driver-name'    => 'postgresql',
           'connection-url' => 'jdbc:postgresql://localhost/postgres',
           'jndi-name'      => 'java:jboss/datasources/DemoDS',
          },
          port_properties => { 'management-http' => 49990, 'management-https' => 49993, 'ajp' => 48009, 'http' => 48080, 'https' => 48443, },
        }

        EOS
        # Run it twice and test for idempotency
        apply_manifest(pp, :catch_failures => false)
        apply_manifest(pp, :catch_changes  => true)
      end
      WILDFLY = [
        {'versie' => '8', 'port' => '19990'},
        {'versie' => '9', 'port' => '29990'},
        {'versie' => '10','port' => '39990'},
        {'versie' => '11','port' => '49990'},
      ]
      WILDFLY.each do |wildfly|
        describe file("/opt/wildfly#{wildfly['versie']}") do
          it { is_expected.to be_directory }
        end
        describe service("wildfly#{wildfly['versie']}") do
          it { is_expected.to be_enabled }
          it { is_expected.to be_running }
        end
        describe 'jboss-cli.sh' do
          it 'check if datasource is present' do
            shell("/opt/wildfly#{wildfly['versie']}/bin/jboss-cli.sh --controller=localhost:#{wildfly['port']} --connect --command=/subsystem=datasources:read-resource", :acceptable_exit_codes => [0]) do |r|
              expect(r.stdout).to match(/postgresql" => undefined/)
            end
          end
        end
      end
    end
  end
end
