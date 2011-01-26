require 'helper'

class TestDbrcLoad < Test::Unit::TestCase
  def test_01_implicit_load
    klassname = 'RDBI::Driver::ImplicitLoadTest'

    hash = RDBI::DBRC.roles
    assert(hash)
    assert(hash.has_key?(:implicit_load_test))
    assert(! module_loaded?(klassname))
    dbh = RDBI::DBRC.connect(:implicit_load_test)
    assert(module_loaded?(klassname))
    assert(dbh)
    assert(dbh.connected?)
    assert_equal(0, dbh.connect_args.select { |k, v| k.to_s =~ /^dbrc_/ }.length)

    assert_kind_of(RDBI::Driver::ImplicitLoadTest, dbh.driver)
  end

  def test_02_no_load
    klassname = 'RDBI::Driver::NoLoadTest'

    hash = RDBI::DBRC.roles
    assert(hash)
    assert(hash.has_key?(:no_load_test))
    assert(! module_loaded?(klassname))
    assert_raises(ArgumentError) do
      RDBI::DBRC.connect(klassname)
    end
    require 'rdbi/driver/noloadtest'
    assert(module_loaded?(klassname))
    dbh = RDBI::DBRC.connect(:no_load_test)
    assert(dbh)
    assert(dbh.connected?)
    assert_equal(0, dbh.connect_args.select { |k, v| k.to_s =~ /^dbrc_/ }.length)
    assert_kind_of(RDBI::Driver::NoLoadTest, dbh.driver)
  end

  def test_03_explicit_load
    klassname = 'RDBI::Driver::ExplicitLoadTest'

    hash = RDBI::DBRC.roles
    assert(hash)
    assert(hash.has_key?(:explicit_load_test))
    assert(! module_loaded?(klassname))
    dbh = RDBI::DBRC.connect(:explicit_load_test)
    assert(module_loaded?(klassname))
    assert(dbh)
    assert(dbh.connected?)
    assert_equal(0, dbh.connect_args.select { |k, v| k.to_s =~ /^dbrc_/ }.length)
    assert_kind_of(RDBI::Driver::ExplicitLoadTest, dbh.driver)
  end

  def test_04_explicit_load_multiple
    klassname = 'RDBI::Driver::ExplicitLoadMultipleTest'
    fooklass = 'AdHoc::Foo'
    barklass = 'AdHoc::Bar'

    hash = RDBI::DBRC.roles
    assert(hash)
    assert(hash.has_key?(:explicit_load_multiple_test))
    assert(! module_loaded?(klassname))
    assert(! module_loaded?(fooklass))
    assert(! module_loaded?(barklass))
    dbh = RDBI::DBRC.connect(:explicit_load_multiple_test)
    assert(module_loaded?(barklass))
    assert(module_loaded?(fooklass))
    assert(module_loaded?(klassname))
    assert(dbh)
    assert(dbh.connected?)
    assert_equal(0, dbh.connect_args.select { |k, v| k.to_s =~ /^dbrc_/ }.length)
    assert_kind_of(RDBI::Driver::ExplicitLoadMultipleTest, dbh.driver)
  end
end
