require 'spec_helper'

describe Exercise do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:title) }

  it { should have_many(:clones).dependent(:destroy) }
  it { should have_many(:solutions).through(:clones) }
  it { should have_many(:solvers).through(:clones) }

  it 'validates uniqueness of title' do
    create(:exercise)
    should validate_uniqueness_of(:title)
  end

  describe '.alphabetical' do
    it 'returns exercises alphabetically by title' do
      create :exercise, title: 'def'
      create :exercise, title: 'abc'
      create :exercise, title: 'ghi'

      result = Exercise.alphabetical

      expect(result.pluck(:title)).to eq(%w(abc def ghi))
    end
  end

  describe '#has_solutions?' do
    context 'with a solution' do
      it 'returns true' do
        exercise = create(:exercise)
        clone = create(:clone, exercise: exercise)
        create(:solution, clone: clone)

        expect(exercise).to have_solutions
      end
    end

    context 'with no solutions' do
      it 'returns false' do
        exercise = build_stubbed(:exercise)

        expect(exercise).not_to have_solutions
      end
    end
  end

  describe '#slug' do
    it 'generates a slug based on the title' do
      exercise = create(:exercise, title: 'Example Title')

      expect(exercise.slug).to eq('example-title')
    end
  end

  describe '#to_param' do
    it 'uses its slug' do
      exercise = build_stubbed(:exercise, slug: 'a-slug')

      expect(exercise.to_param).to eq(exercise.slug)
    end

    it 'returns a findable value' do
      exercise = create(:exercise)

      expect(Exercise.find(exercise.to_param)).to eq(exercise)
    end
  end
end
