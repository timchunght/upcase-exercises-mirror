require 'spec_helper'

describe ImportableParticipation do
  it 'decorates to its component' do
    participation = double('participation', title: 'expected title')
    importable_participation = ImportableParticipation.new(
      participation,
      git_server: double('git_server'),
      shell: double('server')
    )

    expect(importable_participation).to be_a(SimpleDelegator)
    expect(importable_participation.title).to eq('expected title')
  end

  describe '#import' do
    context 'with no solution' do
      it 'submits a solution' do
        diff = '+++ 123'
        tempfile = Tempfile.new('patch')
        Tempfile.stub(:new).with('patch').and_return(tempfile)
        repository = double('repository')
        repository.stub(:commit).and_yield
        clone = double('clone')
        git_clone = double('git_clone', repository: repository)
        git_server = double('git_server')
        Git::Clone.stub(:new).with(clone, git_server).and_return(git_clone)
        solution = double('solution')
        shell = Gitolite::FakeShell.new
        participation = double(
          'participation',
          has_solution?: false,
          find_or_create_clone: clone,
          find_or_create_solution: solution
        )
        importable_participation = ImportableParticipation.new(
          participation,
          git_server: git_server,
          shell: shell
        )

        importable_participation.import(diff)

        expect(repository).to have_received(:commit).
          with('Import solution from GitHub')
        expect(IO.read(tempfile.path)).to eq(diff)
        expect(shell).to have_executed_command("patch -p1 < #{tempfile.path}")
        expect(participation).to have_received(:find_or_create_solution)
      end
    end

    context 'with a solution' do
      it 'does nothing' do
        participation = double('participation', has_solution?: true)
        participation.stub(:find_or_create_clone)
        importable_participation =
          ImportableParticipation.new(participation, shell: double('shell'))

        importable_participation.import('diff')

        expect(participation).not_to have_received(:find_or_create_clone)
      end
    end
  end
end
