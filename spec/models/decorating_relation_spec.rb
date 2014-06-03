require 'spec_helper'

describe DecoratingRelation do
  DecoratingRelation::ITEM_METHODS.each do |method_name|
    describe "##{method_name}" do
      context 'with a matching record' do
        it 'returns the decorated clone' do
          arguments = %w(one two)
          record = double('record')
          decorated_record = double('decorated_record')
          relation = double('relation')
          relation.stub(method_name).with(*arguments).and_return(record)
          decorator = double('decorator')
          decorator.stub(:new).with(record: record).and_return(decorated_record)
          decorating_relation =
            DecoratingRelation.new(relation, :record, decorator)

          result = decorating_relation.send(method_name, *arguments)

          expect(result).to eq(decorated_record)
        end
      end

      context 'with no matching records' do
        it 'returns nil' do
          relation = double('relation', method_name => nil)
          decorating_relation =
            DecoratingRelation.new(relation, :record, double('decorator'))

          result = decorating_relation.send(method_name, 'arguments')

          expect(result).to be_nil
        end
      end
    end
  end
end
