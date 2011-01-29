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
  # driver::    corresponds to the driver you wish to use.  This driver will be
  #             downcased and loaded unless +dbrc_load+ is specified.
  # dbrc_load:: ruby library to load instead of the implicit driver library.
  #             If omitted, the default driver library name is loaded.  If
  #             specified but empty (nil), no driver is loaded.  Otherwise,
  #             loads the named library (or libraries, if a YAML list).
  # dbrc_*::    keys beginning with +dbrc_+ are reserved for future RDBI::DBRC
  #             use, and are currently ignored.
  #
  # For example, given:
  #
  #     ---
  #     memory_connection:
  #       driver: SQLite3      # implicitly load 'rdbi/driver/sqlite3'
  #       database: ":memory:"
  #     experimental:
  #       driver: FauxSQL
  #       dbrc_load:           # do not load '.../fauxsql' (nor any driver)
  #       ...
  #     locally_patched:
  #       driver: Unreliable
  #       dbrc_load:
  #         - rdbi/driver/unreliable    # loads driver explicitly
  #         - local/patches/workaround  # then loads workaround
  #       ...
  #
  # RDBI::DBRC.connect(:memory_connection) would call RDBI.connect like so:
  #
  #     RDBI.connect(:SQLite3, :database => ":memory:")
  #
  # .connect(:experimental) would load no drivers whatsoever, whereas
  # .connect(:locally_patched) would load 'rdbi/driver/unreliable' followed
  # by 'local/patches/workaround' before issuing the underlying connect().
  #
  # If a block is given, it is executed with the newly connected dbh as its
  # sole argument, just a for RDBI.connect.
  #
  # The configuration file is $HOME/.dbrc by default.  Don't like that?
  # Set the +DBRC+ environment variable:
  #
  #     DBRC=/tmp/dbrc my_rdbi_program.rb
  #
  module DBRC
    #
    # Connect to the specified role.
    #
    def self.connect(role, &block)
      role_data = self.roles[role.to_sym]

      unless role_data
        raise ArgumentError, "role '#{role}' does not exist."
      end

      driver = role_data.delete(:driver)
      load_libs = role_data.delete(:dbrc_load) {
                    ["rdbi/driver/#{driver.to_s.downcase}"]
                  } || []
      load_libs = [load_libs] unless load_libs.kind_of?(::Array)
      load_libs.each do |l|
        require l
      end

      role_data.reject! { |k,v| k.to_s =~ /^dbrc_/ }
      RDBI.connect(driver, role_data, &block)
    end

    #
    # Get a RDBI::Pool for the specified role. Defaults to 1 pooled connection.
    # If no pool name is supplied, will use the role name as the pool name.
    #
    def self.pool_connect(role, connections=1, pool_name=role)
      RDBI::Pool.new(pool_name, self.roles[role], connections)
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

