module Yapv
  class Pesel
    include ActiveModel::Validations
    attr_accessor :value

    validates :value, :presence => true, :length => {:is => 11}, :numericality => true
    validate :pesel_format

    def initialize(value)
      self.value = value
    end

    def pesel_format
      mask = [1, 3, 7, 9, 1, 3, 7, 9, 1, 3]
      val = value.split("").map(&:to_i)

      modulo = mask.inject(0){|sum, num| sum + (num * val.shift)} % 10
      errors.add(:value) unless 10 - modulo == val.shift
    end

    def gender
      return unless valid?
      value[-2].to_i % 2 == 0 ? :female : :male
    end

    def gender!
      raise ArgumentError.new("PESEL is invalid") unless gender
      gender
    end

    def male?
      raise ArgumentError.new("PESEL is invalid") unless valid?
      gender == :male
    end

    def female?
      raise ArgumentError.new("PESEL is invalid") unless valid?
      gender == :female
    end

    def birth_date
      return unless valid?
      case value[2].to_i
      when 0..1
        century = "19"
        offset = 0
      when 2..3
        century = "20"
        offset = 20
      when 4..5
        century = "21"
        offset = 40
      when 6..7
        century = "22"
        offset = 60
      when 8..9
        century = "18"
        offset = 80
      end

      year, month, day = value[0,6].scan(/\d\d/)
      month = month.to_i - offset
      Date.parse("#{century}#{year}-#{month}-#{day}")
    end

    def birth_date!
      raise ArgumentError.new("PESEL is invalid") unless birth_date
      birth_date
    end
  end
end