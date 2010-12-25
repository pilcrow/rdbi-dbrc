require 'rdbi'
require 'yaml'

module RDBI # :nodoc:
  #
  # RDBI::DBRC - yaml-based connection configurations for RDBI
  #
  # If you know a little YAML, using DBRC is easy:
  #
  # Connections are keyed by a role and then subkeyed by connection parameters,
  # with a few exceptions which are not passed along: 
  #
  # driver:: corresponds to the driver you wish to use. This driver must
  #          already be loaded before the role is leveraged.
  #
  # For example:
  #
  #     memory_connection:
  #       driver: SQLite3
  #       database: ":memory:"
  #
  # RDBI::DBRC.connect will call RDBI.connect like so:
  #
  #     RDBI.connect(:SQLite3, :database => ":memory:")
  #
  # The file lives by default in $HOME/.dbrc. Don't like that? Set the +DBRC+
  # environment parameter:
  #
  #     DBRC=/tmp/dbrc my_rdbi_program.rb
  #
  module DBRC
    #
    # Connect to the specified role.
    #
    def self.connect(role)
      role_data = self.roles[role.to_sym]

      unless role_data
        raise ArgumentError, "role '#{role}' does not exist."
      end

      driver = role_data.delete(:driver)

      RDBI.connect(driver, role_data)
    end

    # 
    # Obtain role information. Returns a hash of hashes.
    #
    def self.roles
      rcfile = ENV["DBRC"] || File.expand_path(File.join(ENV["HOME"], '.dbrc'))

      # XXX the rc file should only be two levels deep, so instead of mentarbating
      # XXX with recursion, let's just do it the cheap way.

      hash = RDBI::Util.key_hash_as_symbols(YAML.load_file(rcfile))
      hash.each do |key, value|
        hash[key] = RDBI::Util.key_hash_as_symbols(hash[key])
      end

      hash
    end
  end
end
