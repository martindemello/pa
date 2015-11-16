require 'pry'
module PennyAllocation
  def reallocate_partial_pennies(values, options = {})
    floored_values_with_fractional_remainders(values).sort_by do |hash|
      1 - hash[:fractional_value]
    end.each_with_index.map do |hash, index|
      if index_less_than_number_to_allocate(index, options, values)
        hash.merge({value: hash[:value] + 1})
      else
        hash
      end
    end.sort_by do |hash|
      hash[:index]
    end.map do |hash|
      hash[:value]
    end
  end

  def round_comp_total(number)
    if fractional_value(number) == 0.500000
      number.floor
    else
      number.round
    end
  end

  private

  def index_less_than_number_to_allocate(index, options, array_of_values)
    index < number_to_allocate(options, fractional_sum(array_of_values))
  end

  def fractional_sum(values)
    values.map do |val|
      fractional_value(val)
    end.inject(&:+)
  end

  def floored_values_with_fractional_remainders(values)
    values.each_with_index.map do |v, original_position|
      {fractional_value: fractional_value(v), value: v.floor, index: original_position}
    end
  end

  def fractional_value(value)
    value % 1
  end

  def number_to_allocate(options, fractional_sum)
    if options[:comp_total]
        round_comp_total(fractional_sum)
    else
      fractional_sum.round
    end
  end
end
