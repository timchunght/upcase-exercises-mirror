require 'spec_helper'

describe CloneQuery do
  describe '#for_user' do
    context 'with an existing clone' do
      it 'returns the clone' do
        user = double('user', id: 123)
        clone = double('clone')
        relation = double('relation')
        relation.stub(:find_by).with(user_id: user.id).and_return(clone)
        query = CloneQuery.new(relation)

        result = query.for_user(user)

        expect(result).to eq(clone)
      end
    end

    context 'without an existing clone' do
      it 'returns nil' do
        user = create(:user)
        query = CloneQuery.new(Clone.all)

        result = query.for_user(user)

        expect(result).to be_nil
      end
    end
  end

  describe '#create!' do
    it 'delegates to its relation' do
      expected = double('expected')
      arguments = double('arguments')
      relation = double('relation')
      relation.stub(:create!).and_return(expected)
      query = CloneQuery.new(relation)

      result = query.create!(arguments)

      expect(relation).to have_received(:create!).with(arguments)
      expect(result).to eq(expected)
    end
  end
end