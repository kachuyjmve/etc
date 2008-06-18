require "test/unit"
require "etc"

class TestEtc < Test::Unit::TestCase
  def test_getlogin
    s = Etc.getlogin
    assert(s.is_a?(String) || s == nil, "getlogin must return a String or nil")
  end

  def test_passwd
    Etc.passwd do |s|
      assert_instance_of(String, s.name)
      assert_instance_of(String, s.passwd) if s.respond_to?(:passwd)
      assert_kind_of(Integer, s.uid)
      assert_kind_of(Integer, s.gid)
      assert_instance_of(String, s.gecos) if s.respond_to?(:gecos)
      assert_instance_of(String, s.dir)
      assert_instance_of(String, s.shell)
      assert_kind_of(Integer, s.change) if s.respond_to?(:change)
      assert_kind_of(Integer, s.quota) if s.respond_to?(:quota)
      assert_kind_of(Integer, s.age) if s.respond_to?(:age)
      assert_instance_of(String, s.uclass) if s.respond_to?(:uclass)
      assert_instance_of(String, s.comment) if s.respond_to?(:comment)
      assert_kind_of(Integer, s.expire) if s.respond_to?(:expire)
    end

    assert_raise(RuntimeError) { Etc.passwd { Etc.passwd { } } }
  end

  def test_getpwuid
    Etc.passwd do |s|
      assert_equal(s, Etc.getpwuid(s.uid))
      assert_equal(s, Etc.getpwuid) if Etc.getlogin == s.name
    end
  end

  def test_getpwnam
    Etc.passwd do |s|
      assert_equal(s, Etc.getpwnam(s.name))
    end
  end

  def test_setpwent
    a = []
    Etc.passwd do |s|
      a << s
      Etc.setpwent if a.size == 3
    end
    assert_equal(a[0, 3], a[3, 3]) if a.size >= 6
  end

  def test_getpwent
    a = []
    Etc.passwd {|s| a << s }
    b = []
    Etc.passwd do |s|
      b << s
      s = Etc.getpwent
      break unless s
      b << s
    end
    assert_equal(a, b)
  end

  def test_endpwent
    a = []
    Etc.passwd do |s|
      a << s
      Etc.endpwent if a.size == 3
    end
    assert_equal(a[0, 3], a[3, 3]) if a.size >= 6
  end

  def test_group
    Etc.group do |s|
      assert_instance_of(String, s.name)
      assert_instance_of(String, s.passwd) if s.respond_to?(:passwd)
      assert_kind_of(Integer, s.gid)
    end

    assert_raise(RuntimeError) { Etc.group { Etc.group { } } }
  end

  def test_getgrgid
    groups = []
    Etc.group do |s|
      groups << s
    end
    groups.each do |s|
      assert_equal(s, Etc.getgrgid(s.gid))
      assert_equal(s, Etc.getgrgid) if Etc.getlogin == s.name
    end
  end

  def test_getgrnam
    groups = []
    Etc.group do |s|
      groups << s
    end
    groups.each do |s|
      assert_equal(s, Etc.getgrnam(s.name))
    end
  end

  def test_setgrent
    a = []
    Etc.group do |s|
      a << s
      Etc.setgrent if a.size == 3
    end
    assert_equal(a[0, 3], a[3, 3]) if a.size >= 6
  end

  def test_getgrent
    a = []
    Etc.group {|s| a << s }
    b = []
    Etc.group do |s|
      b << s
      s = Etc.getgrent
      break unless s
      b << s
    end
    assert_equal(a, b)
  end

  def test_endgrent
    a = []
    Etc.group do |s|
      a << s
      Etc.endgrent if a.size == 3
    end
    assert_equal(a[0, 3], a[3, 3]) if a.size >= 6
  end
end