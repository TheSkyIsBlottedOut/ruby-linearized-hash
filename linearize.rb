# Converts a hash to a nested keyvalue
class Hash
  def linearize(predicate = nil)
    return_value = []
    each_pair do |key, value|
      new_predicate = key.to_s
      new_predicate = [predicate, new_predicate].join(?.) if predicate
      case value
      when Hash
        return_value.concat value.linearize(new_predicate)
      when Array
        return_value.concat value.linearize(new_predicate)
      else
        return_value << [new_predicate, value.to_s]
      end
    end
    return_value
  end
end


class Array
  def linearize(predicate = nil)
    return_value = []
    each_with_index do |v,i|
      this_predicate = (predicate || '') + "[#{i}]"
      case v
      when Hash
        return_value.concat v.linearize(this_predicate)
      when Array
        return_value.concat v.linearize(this_predicate)
      else
        return_value << [this_predicate, v.to_s]
      end
    end
    return_value
  end
end

# TODO: Reverse case in Array

if __FILE__ == $0 # testcase/proof
  test_hash = {
    :foo => :bar,
    :array => [{:array_obj => 1, 2 => [{:foo => :bar}, 1, false]}, {:array_obj => 2}],
    :hash => {:hash => {:hash => []}}
  }
  p test_hash.linearize
end
