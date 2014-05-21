require 'spec_helper'

describe Git::DiffLine do
  describe '#text' do
    it 'returns the value given during initialization' do
      expect(Git::DiffLine.new('hello', true, 1).text).to eq('hello')
    end
  end

  describe '#number' do
    it 'returns the value given during initialization' do
      expect(Git::DiffLine.new('hello', true, 1).number).to eq(1)
    end
  end

  describe '#to_s' do
    context 'for a changed line' do
      it 'returns the line in diff format' do
        expect(Git::DiffLine.new('hello', true, 1).to_s).to eq('+hello')
      end
    end

    context 'for an unchanged line' do
      it 'returns the line in diff format' do
        expect(Git::DiffLine.new('hello', false, 1).to_s).to eq(' hello')
      end
    end
  end

  describe '#blank?' do
    context 'with blank text' do
      it 'returns true' do
        expect(Git::DiffLine.new('', true, 1)).to be_blank
      end
    end

    context 'with present text' do
      it 'returns false' do
        expect(Git::DiffLine.new('hello', true, 1)).not_to be_blank
      end
    end
  end

  describe '#changed?' do
    it 'returns the value given during initialization' do
      changed = double('changed')
      expect(Git::DiffLine.new('hello', changed, 1).changed?).to eq(changed)
    end
  end
end
