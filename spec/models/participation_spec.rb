require 'spec_helper'

describe Participation do
  describe '#has_clone?' do
    context 'with no existing clone' do
      it 'returns false' do
        participation = build_participation(existing_clone: nil)

        expect(participation).not_to have_clone
      end
    end

    context 'with an existing clone' do
      it 'returns true' do
        existing_clone = build_stubbed(:clone)
        participation = build_participation(existing_clone: existing_clone)

        expect(participation).to have_clone
      end
    end
  end

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

  describe '#create_clone' do
    it 'tells the Git server to clone an exercise for the given user' do
      exercise = build_stubbed(:exercise)
      user = build_stubbed(:user)
      git_server = double('git_server')
      git_server.stub(:create_clone)
      participation = build_participation(
        exercise: exercise,
        user: user,
        git_server: git_server
      )

      participation.create_clone

      expect(git_server).to have_received(:create_clone).with(exercise, user)
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
        solution.stub(:create_revision!)
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
        expect(solution).to have_received(:create_revision!).with(diff: diff)
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

  describe '#update_solution' do
    context 'with an existing clone and solution' do
      it 'updates existing solution' do
        diff = double('diff')
        clone = build_stubbed(:clone)
        solution = build_stubbed(:solution)
        solution.stub(:create_revision!)
        clone.stub(:solution).and_return(solution)
        user = build_stubbed(:user)
        git_server = stub_git_server(clone: clone, diff: diff)
        participation = build_participation(
          existing_clone: clone,
          user: user,
          git_server: git_server
        )

        participation.update_solution

        expect(solution).to have_received(:create_revision!).with(diff: diff)
      end
    end

    context 'with an existing clone but no solution' do
      it 'does nothing' do
        clone = build_stubbed(:clone)
        clone.stub(:solution).and_return(nil)
        git_server = stub_git_server
        participation = build_participation(
          existing_clone: clone,
          git_server: git_server
        )

        participation.update_solution

        expect(git_server).not_to have_received(:fetch_diff)
      end
    end

    context 'with no existing clone' do
      it 'does nothing' do
        user = build_stubbed(:user)
        git_server = stub_git_server
        participation = build_participation(user: user, git_server: git_server)

        participation.update_solution

        expect(git_server).not_to have_received(:fetch_diff)
      end
    end
  end

  def stub_git_server(options = {})
    double('git_server').tap do |git_server|
      git_server.
        stub(:fetch_diff).
        with(options[:clone]).
        and_return(options[:diff] || 'diff')
    end
  end

  def build_participation(
    clones: double('clones'),
    exercise: build_stubbed(:exercise),
    existing_clone: nil,
    git_server: double('git_server'),
    user: build_stubbed(:user)
  )
    clones.stub(:for_user).with(user).and_return(existing_clone)
    Participation.new(
      exercise: exercise,
      git_server: git_server,
      user: user,
      clones: clones,
    )
  end
end
