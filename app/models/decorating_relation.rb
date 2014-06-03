# Decorates an ActiveRecord::Relation and applies the given decorator to records
# returned from the relation.
class DecoratingRelation
  ITEM_METHODS = %i(create create! find find_by first last new).freeze

  pattr_initialize :relation, :key, :decorator

  ITEM_METHODS.each do |method_name|
    define_method method_name do |*args|
      record = relation.send(method_name, *args)
      if record
        decorator.new key => record
      end
    end
  end
end
