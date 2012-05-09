require "test_helper"
require "date"
class PeselTest < MiniTest::Unit::TestCase
  def test_pesel_shorter_than_11_digits_is_invalid
    @pesel = Yapv::Pesel.new("1" * 10)
    assert !@pesel.valid?
  end

  def test_pesel_lenghten_than_11_digits_is_invalid
    @pesel = Yapv::Pesel.new("1" * 12)
    assert !@pesel.valid?
  end

  def test_pesel_with_non_digit_characters_is_invalid
    @pesel = Yapv::Pesel.new("1234567890a")
    assert !@pesel.valid?
  end

  def test_incorrect_pesel_is_invalid
    ["75120804350"].each do |pesel|
      @pesel = Yapv::Pesel.new(pesel)
      assert !@pesel.valid?, "Pesel: #{pesel} should be invalid"
    end
  end

  def test_correct_pesel_is_valid
    ["74021834018", "02221407563"].each do |pesel|
      @pesel = Yapv::Pesel.new(pesel)
      assert @pesel.valid?, "Pesel #{pesel} should be valid"
    end
  end

  def test_birth_date_returns_correct_date
    [["74082610668", "1974-08-26"], ["02221407563", "2002-02-14"]].each do |row|
      pesel, expected_date = row
      @pesel = Yapv::Pesel.new(pesel)
      assert_equal Date.parse(expected_date), @pesel.birth_date
    end
  end

  def test_birth_date_with_bang_raises_error_with_incorrect_pesel
    @pesel = Yapv::Pesel.new("74082610618")
    assert_raises ArgumentError do
      @pesel.birth_date!
    end
  end

  def test_birth_date_returns_nil_if_pesel_is_incorrect
    ["74082610618", "02221407513"].each do |pesel|
      @pesel = Yapv::Pesel.new(pesel)
      assert_equal nil, @pesel.birth_date
    end
  end

  def test_gender_method_returns_male_for_male_pesel
    @pesel = Yapv::Pesel.new("74021834018")
    assert @pesel.male?
    assert @pesel.gender == :male
  end

  def test_gender_method_returns_female_for_female_pesel
    @pesel = Yapv::Pesel.new("02221407563")
    assert @pesel.female?
    assert @pesel.gender == :female
  end

  def test_gender_returns_nil_if_pesel_is_incorrect
    @pesel = Yapv::Pesel.new("74082610618")
    assert_equal nil, @pesel.gender
  end

  def test_gender_with_bang_raises_error_with_incorrect_pesel
    @pesel = Yapv::Pesel.new("74082610618")
    assert_raises ArgumentError do
      @pesel.gender!
    end
  end

  def test_male_and_female_inquirer_raises_error_if_pesel_is_incorrect
    @pesel = Yapv::Pesel.new("74082610618")
    assert_raises ArgumentError, "male? method should raise ArgumentError" do
      @pesel.male?
    end

    assert_raises ArgumentError, "female? method should raise ArgumentError" do
      @pesel.female?
    end
  end
end