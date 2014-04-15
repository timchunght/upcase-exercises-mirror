require 'spec_helper'

describe Git::DiffFile do
  describe '#blank?' do
    context 'before adding a line' do
      it 'returns true' do
        file = Git::DiffFile.new
        file.puts 'line'

        expect(file).not_to be_blank
      end
    end

    context 'after adding a line' do
      it 'returns false' do
        file = Git::DiffFile.new

        expect(file).to be_blank
      end
    end
  end

  describe '#name' do
    it 'returns its assigned name' do
      file = Git::DiffFile.new

      file.name = 'expected name'

      expect(file.name).to eq('expected name')
    end
  end

  describe '#puts' do
    it 'appends a line to its buffer' do
      file = Git::DiffFile.new

      file.puts 'one'
      file.puts 'two'
      file.puts 'three'

      expect(file.each_line.to_a.join).to eq("one\ntwo\nthree\n")
    end
  end
end
