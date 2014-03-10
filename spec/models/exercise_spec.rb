require 'spec_helper'

describe Exercise do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:title) }

  it 'validates uniqueness of title' do
    create(:exercise)
    should validate_uniqueness_of(:title)
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
