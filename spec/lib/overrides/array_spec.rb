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

      it 'apply throttling concurrency' do
        total_concurrent_map_3_threads_time =
          Benchmark.realtime do
            (1..6).to_a.concurrent_map(max_threads: 3) { sleep(0.5) }
          end

        total_concurrent_map_6_threads_time =
          Benchmark.realtime do
            (1..6).to_a.concurrent_map(max_threads: 6) { sleep(1) }
          end

        expect(total_concurrent_map_3_threads_time.round).to eq 1
        expect(total_concurrent_map_6_threads_time.round).to eq 1
      end
    end
  end

  describe '#concurrent_map_hash' do # rubocop:disable Metrics/BlockLength
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

      @data_processed = @data.concurrent_map_hash { |e| e.merge(value: e[:id] * 2) }
    end

    context 'OK when' do
      it 'process concurrent' do
        total_concurrent_map_hash_time =
          Benchmark.realtime do
            @data.concurrent_map_hash do |e|
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

         expect(total_concurrent_map_hash_time).to be < total_ruby_map_time # rubocop:disable Layout/IndentationConsistency
      end

      it 'result does not miss elements' do
        expect(@data_processed.count).to eq @data.count
      end

      it 'keep index elements' do
        @data.each_with_index do |element, idx|
          expect(element[:id]).to eq @data[idx][:id]
        end
      end

      it 'apply throttling concurrency' do
        total_concurrent_map_5_threads_time =
          Benchmark.realtime do
            @data.concurrent_map_hash(max_threads: 5) do |element|
              sleep(0.5)
              element
            end
          end

        total_concurrent_map_10_threads_time =
          Benchmark.realtime do
            @data.concurrent_map_hash(max_threads: 10) do |element|
              sleep(0.5)
              element
            end
          end

        expect(total_concurrent_map_5_threads_time.round).to eq 1
        expect(total_concurrent_map_10_threads_time.round).to eq 1
      end
    end

    context 'FAIL when' do
      it 'wrong data type' do
        expect { [[1], [2], [3]].concurrent_map_hash }.to raise_error(RuntimeError, 'WrongDataType')
      end
    end
  end
end
