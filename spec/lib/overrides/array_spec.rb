# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Array do # rubocop:disable Metrics/BlockLength
  describe '#concurrent_map' do # rubocop:disable Metrics/BlockLength
    before do
      @data = (1..10).to_a

      @data_processed = @data.concurrent_map { |e| e * 2 }
    end

    context 'OK when' do
      it 'process concurrent' do
        total_concurrent_map_time =
          Benchmark.realtime do
            @data.concurrent_map do |e|
              sleep(0.1)

              e * 2
            end
          end

        total_ruby_map_time =
          Benchmark.realtime do
            @data.map do |e|
              sleep(0.1)

              e * 2
            end
          end

         expect(total_concurrent_map_time).to be < total_ruby_map_time # rubocop:disable Layout/IndentationConsistency
      end

      it 'result does not miss elements' do
        expect(@data_processed.count).to eq @data.count
      end

      # https://github.com/ruby-concurrency/concurrent-ruby/blob/master/docs-source/promises.in.md#throttling-concurrency
      it 'apply Throttling concurrency'
    end
  end

  describe '#concurrent_hash_map' do # rubocop:disable Metrics/BlockLength
    before do
      @data = [
        { id: 1, name: 'Element 1' },
        { id: 2, name: 'Element 2' },
        { id: 3, name: 'Element 3' },
        { id: 4, name: 'Element 4' },
        { id: 5, name: 'Element 5' },
        { id: 6, name: 'Element 6' },
        { id: 7, name: 'Element 7' },
        { id: 8, name: 'Element 8' },
        { id: 9, name: 'Element 9' },
        { id: 10, name: 'Element 10' },
      ]

      @data_processed = @data.concurrent_hash_map { |e| e.merge(value: e[:id] * 2) }
    end

    context 'OK when' do
      it 'process concurrent' do
        total_concurrent_hash_map_time =
          Benchmark.realtime do
            @data.concurrent_hash_map do |e|
              sleep(0.1)

              e.merge(value: e[:id] * 2)
            end
          end

        total_ruby_map_time =
          Benchmark.realtime do
            @data.map do |e|
              sleep(0.1)

              e.merge(value: e[:id] * 2)
            end
          end

         expect(total_concurrent_hash_map_time).to be < total_ruby_map_time # rubocop:disable Layout/IndentationConsistency
      end

      it 'result does not miss elements' do
        expect(@data_processed.count).to eq @data.count
      end

      it 'keep index elements' do
        @data.each_with_index do |element, idx|
          expect(element[:id]).to eq @data[idx][:id]
        end
      end

      # https://github.com/ruby-concurrency/concurrent-ruby/blob/master/docs-source/promises.in.md#throttling-concurrency
      it 'apply Throttling concurrency'
    end

    context 'FAIL when' do
      it 'wrong data type' do
        expect { [[1], [2], [3]].concurrent_hash_map }.to raise_error(RuntimeError, 'WrongDataType')
      end
    end
  end
end
