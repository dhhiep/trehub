# frozen_string_literal: true

class Array
  def concurrent_map(&block)
    futures =
      map do |element|
        Concurrent::Promises.future(element, &block)
      end

    futures.compact.map(&:value!)
  end

  def concurrent_hash_map(&block)
    futures =
      map.with_index do |element, index|
        raise 'WrongDataType' unless element.is_a?(Hash)

        element[:sort_index] = index

        Concurrent::Promises.future(element, &block)
      end

    futures.compact.map(&:value!).sort_by_index
  end

  def sort_by_index
    sort_by { |element| element[:sort_index] }
  end
end
