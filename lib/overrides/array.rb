# frozen_string_literal: true

class Array
  def concurrent_map(max_threads: 100, &block)
    throttle = Concurrent::Throttle.new(max_threads)

    futures =
      map do |element|
        throttle.future(element, &block)
      end

    futures.compact.map(&:value!)
  end

  def concurrent_map_hash(max_threads: 100, &block)
    attach_sort_index_key!

    concurrent_map(max_threads: max_threads, &block).sort_by_index
  end

  def sort_by_index
    sort_by { |element| element.is_a?(Hash) ? element[:sort_index] : 1 }
  end

  private

  def attach_sort_index_key!
    map.with_index do |element, index|
      raise 'WrongDataType' unless element.is_a?(Hash)

      element[:sort_index] = index
      element
    end
  end
end
