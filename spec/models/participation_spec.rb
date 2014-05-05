require 'spec_helper'

describe Participation do
  describe '#find_clone_for' do
    context 'with no existing clone' do
      it 'raises an exception' do
        user = build_stubbed(:user)
        participation = build_participation(user: user)

        expect { participation.find_clone }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with an existing clone' do
      it 'returns the existing clone' do
        existing_clone = build_stubbed(:clone)
        user = build_stubbed(:user)
        participation =
          build_participation(existing_clone: existing_clone, user: user)

        result = participation.find_clone

        expect(result).to eq(existing_clone)
      end
    end
  end

  describe '#find_or_create_clone_for' do
    context 'with no existing clone' do
      it 'tells the Git server to clone for the given user' do
        sha = 'abc123'
        exercise = build_stubbed(:exercise)
        user = build_stubbed(:user)
        clone = build_stubbed(:clone)
        git_server = double('git_server')
        git_server.stub(:create_clone).with(exercise, user).and_return(sha)
        exercise.
          clones.
          stub(:create!).
          with(user: user, parent_sha: sha).
          and_return(clone)
        participation = build_participation(
          exercise: exercise,
          user: user,
          git_server: git_server
        )

        result = participation.find_or_create_clone

        expect(result).to eq(clone)
      end
    end

    context 'with an existing clone' do
      it 'returns the existing clone' do
        existing_clone = build_stubbed(:clone)
        user = build_stubbed(:user)
        participation = build_participation(
          existing_clone: existing_clone,
          user: user
        )
        result = participation.find_or_create_clone

        expect(result).to eq(existing_clone)
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
        participation =
          build_participation(existing_clone: existing_clone, user: user)

        result = participation.find_or_create_solution

        expect(result).to eq(existing_solution)
      end
    end

    context 'with an existing clone but no solution' do
      it 'creates a new solution' do
        diff = double('diff')
        solution = build_stubbed(:solution)
        solution.stub(:create_snapshot!)
        clone = build_stubbed(:clone)
        clone.stub(:solution).and_return(nil)
        clone.stub(:create_solution!).and_return(solution)
        user = build_stubbed(:user)
        git_server = double('git_server')
        git_server.stub(:fetch_diff).with(clone).and_return(diff)
        participation = build_participation(
          existing_clone: clone,
          user: user,
          git_server: git_server
        )

        result = participation.find_or_create_solution

        expect(result).to eq(solution)
        expect(solution).to have_received(:create_snapshot!).with(diff: diff)
      end
    end

    context 'with no existing clone' do
      it 'raises an exception' do
        user = build_stubbed(:user)
        participation = build_participation(user: user)

        expect { participation.find_or_create_solution }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#has_solution?' do
    context 'with a clone and a solution' do
      it 'returns true' do
        existing_clone = build_stubbed(:clone)
        existing_solution = build_stubbed(:solution)
        existing_clone.stub(:solution).and_return(existing_solution)
        user = build_stubbed(:user)
        participation =
          build_participation(existing_clone: existing_clone, user: user)

        expect(participation).to have_solution
      end
    end

    context 'with a clone and no solution' do
      it 'returns false' do
        existing_clone = build_stubbed(:clone)
        existing_clone.stub(:solution).and_return(nil)
        user = build_stubbed(:user)
        participation =
          build_participation(existing_clone: existing_clone, user: user)

        expect(participation).not_to have_solution
      end
    end

    context 'without a clone' do
      it 'returns false' do
        user = build_stubbed(:user)
        participation = build_participation(user: user)

        expect(participation).not_to have_solution
      end
    end
  end

  describe '#find_solution' do
    context 'with an existing clone and solution' do
      it 'returns the existing solution' do
        existing_clone = build_stubbed(:clone)
        existing_solution = build_stubbed(:solution)
        existing_clone.stub(:solution).and_return(existing_solution)
        user = build_stubbed(:user)
        participation =
          build_participation(existing_clone: existing_clone, user: user)

        result = participation.find_solution

        expect(result).to eq(existing_solution)
      end
    end

    context 'with an existing clone but no solution' do
      it 'raises an exception' do
        existing_clone = build_stubbed(:clone)
        existing_clone.stub(:solution).and_return(nil)
        user = build_stubbed(:user)
        participation =
          build_participation(existing_clone: existing_clone, user: user)

        expect { participation.find_solution }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with no existing clone' do
      it 'raises an exception' do
        user = build_stubbed(:user)
        participation = build_participation(user: user)

        expect { participation.find_solution }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  def build_participation(arguments)
    exercise = arguments[:exercise] || build_stubbed(:exercise)
    exercise.
      clones.
      stub(:find_by_user_id).
      with(arguments[:user].id).
      and_return(arguments[:existing_clone])
    Participation.new(
      exercise: exercise,
      git_server: arguments[:git_server] || double('git_server'),
      user: arguments[:user]
    )
  end
end
