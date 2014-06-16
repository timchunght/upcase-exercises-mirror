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

  describe '#find_or_create_solution' do
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
        solution = build_stubbed(:solution)
        clone = build_stubbed(:clone)
        clone.stub(:solution).and_return(nil)
        clone.stub(:create_solution!).and_return(solution)
        participation = build_participation(existing_clone: clone)

        result = participation.find_or_create_solution

        expect(result).to eq(solution)
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

  describe '#push_to_clone' do
    context 'with an existing clone' do
      it 'updates existing solution' do
        clone = build_stubbed(:clone)
        git_server = stub_git_server(clone: clone)
        participation = build_participation(
          existing_clone: clone,
          git_server: git_server
        )

        participation.push_to_clone

        expect(git_server).to have_received(:fetch_diff).with(clone)
      end
    end

    context 'with no existing clone' do
      it 'does nothing' do
        git_server = stub_git_server
        participation = build_participation(git_server: git_server)

        participation.push_to_clone

        expect(git_server).not_to have_received(:fetch_diff)
      end
    end
  end

  describe '#unpushed?' do
    context 'with no clone' do
      it 'returns true' do
        participation = build_participation(existing_clone: nil)

        expect(participation).to be_unpushed
      end
    end

    context 'with a clone but no revisions' do
      it 'returns true' do
        clone = build_stubbed(:clone)
        clone.revisions.stub(:any?).and_return(false)
        participation = build_participation(existing_clone: clone)

        expect(participation).to be_unpushed
      end
    end

    context 'with a clone and revisions' do
      it 'returns false' do
        clone = build_stubbed(:clone)
        clone.revisions.stub(:any?).and_return(true)
        participation = build_participation(existing_clone: clone)

        expect(participation).not_to be_unpushed
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
