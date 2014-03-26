require 'spec_helper'

describe Exercise do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:title) }

  it { should have_many(:clones).dependent(:destroy) }

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

  describe '#find_or_create_clone_for' do
    context 'with no existing clone' do
      it 'tells the Git server to clone for the given user' do
        new_clone = build_stubbed(:clone)
        user = build_stubbed(:user)
        exercise = stub_exercise(new_clone: new_clone, user: user)

        result = exercise.find_or_create_clone_for(user)

        expect(result).to eq(new_clone)
        expect(GIT_SERVER).to have_received(:create_clone).with(exercise, user)
      end
    end

    context 'with an existing clone' do
      it 'returns the existing clone' do
        existing_clone = build_stubbed(:clone)
        user = build_stubbed(:user)
        exercise = stub_exercise(existing_clone: existing_clone, user: user)

        result = exercise.find_or_create_clone_for(user)

        expect(result).to eq(existing_clone)
        expect(GIT_SERVER).not_to have_received(:create_clone)
      end
    end

    def stub_exercise(arguments)
      GIT_SERVER.stub(:create_clone)
      build_stubbed(:exercise).tap do |exercise|
        exercise
          .clones
          .stub(:find_by_user_id)
          .with(arguments[:user].id)
          .and_return(arguments[:existing_clone])
        exercise
          .clones
          .stub(:create!)
          .with(user: arguments[:user])
          .and_return(arguments[:new_clone] || build_stubbed(:clone))
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
