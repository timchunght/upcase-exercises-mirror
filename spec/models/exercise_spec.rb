require 'spec_helper'

describe Exercise do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:title) }

  it { should have_many(:clones).dependent(:destroy) }
  it { should have_many(:solutions).through(:clones) }

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

  describe '#find_clone_for' do
    context 'with no existing clone' do
      it 'raises an exception' do
        user = build_stubbed(:user)
        exercise = stub_clonable_exercise(user: user)

        expect { exercise.find_clone_for(user) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with an existing clone' do
      it 'returns the existing clone' do
        existing_clone = build_stubbed(:clone)
        user = build_stubbed(:user)
        exercise =
          stub_clonable_exercise(existing_clone: existing_clone, user: user)

        result = exercise.find_clone_for(user)

        expect(result).to eq(existing_clone)
      end
    end
  end

  describe '#find_or_create_clone_for' do
    context 'with no existing clone' do
      it 'tells the Git server to clone for the given user' do
        new_clone = build_stubbed(:clone)
        user = build_stubbed(:user)
        exercise = stub_clonable_exercise(new_clone: new_clone, user: user)

        result = exercise.find_or_create_clone_for(user)

        expect(result).to eq(new_clone)
        expect(GIT_SERVER).to have_received(:create_clone).with(exercise, user)
      end
    end

    context 'with an existing clone' do
      it 'returns the existing clone' do
        existing_clone = build_stubbed(:clone)
        user = build_stubbed(:user)
        exercise =
          stub_clonable_exercise(existing_clone: existing_clone, user: user)

        result = exercise.find_or_create_clone_for(user)

        expect(result).to eq(existing_clone)
        expect(GIT_SERVER).not_to have_received(:create_clone)
      end
    end
  end

  describe '#find_or_create_solution_for' do
    context 'with an existing clone and solution' do
      it 'returns the existing solution' do
        existing_clone = build_stubbed(:clone)
        existing_solution = build_stubbed(:solution)
        existing_clone.stub(:solution).and_return(existing_solution)
        user = build_stubbed(:user)
        exercise =
          stub_clonable_exercise(existing_clone: existing_clone, user: user)

        result = exercise.find_or_create_solution_for(user)

        expect(result).to eq(existing_solution)
      end
    end

    context 'with an existing clone but no solution' do
      it 'creates a new solution' do
        new_solution = build_stubbed(:solution)
        existing_clone = build_stubbed(:clone)
        existing_clone.stub(:solution).and_return(nil)
        existing_clone.stub(:create_solution!).and_return(new_solution)
        user = build_stubbed(:user)
        exercise =
          stub_clonable_exercise(existing_clone: existing_clone, user: user)

        result = exercise.find_or_create_solution_for(user)

        expect(result).to eq(new_solution)
      end
    end

    context 'with no existing clone' do
      it 'raises an exception' do
        user = build_stubbed(:user)
        exercise = stub_clonable_exercise(user: user)

        expect { exercise.find_or_create_solution_for(user) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#solved_by?' do
    context 'with a clone and a solution' do
      it 'returns true' do
        existing_clone = build_stubbed(:clone)
        existing_solution = build_stubbed(:solution)
        existing_clone.stub(:solution).and_return(existing_solution)
        user = build_stubbed(:user)
        exercise =
          stub_clonable_exercise(existing_clone: existing_clone, user: user)

        expect(exercise).to be_solved_by(user)
      end
    end

    context 'with a clone and no solution' do
      it 'returns false' do
        existing_clone = build_stubbed(:clone)
        existing_clone.stub(:solution).and_return(nil)
        user = build_stubbed(:user)
        exercise =
          stub_clonable_exercise(existing_clone: existing_clone, user: user)

        expect(exercise).not_to be_solved_by(user)
      end
    end

    context 'without a clone' do
      it 'returns false' do
        user = build_stubbed(:user)
        exercise = stub_clonable_exercise(user: user)

        expect(exercise).not_to be_solved_by(user)
      end
    end
  end

  describe '#find_solution_for' do
    context 'with an existing clone and solution' do
      it 'returns the existing solution' do
        existing_clone = build_stubbed(:clone)
        existing_solution = build_stubbed(:solution)
        existing_clone.stub(:solution).and_return(existing_solution)
        user = build_stubbed(:user)
        exercise =
          stub_clonable_exercise(existing_clone: existing_clone, user: user)

        result = exercise.find_solution_for(user)

        expect(result).to eq(existing_solution)
      end
    end

    context 'with an existing clone but no solution' do
      it 'raises an exception' do
        existing_clone = build_stubbed(:clone)
        existing_clone.stub(:solution).and_return(nil)
        user = build_stubbed(:user)
        exercise =
          stub_clonable_exercise(existing_clone: existing_clone, user: user)

        expect { exercise.find_solution_for(user) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with no existing clone' do
      it 'raises an exception' do
        user = build_stubbed(:user)
        exercise = stub_clonable_exercise(user: user)

        expect { exercise.find_solution_for(user) }
          .to raise_error(ActiveRecord::RecordNotFound)
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

  def stub_clonable_exercise(arguments)
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
