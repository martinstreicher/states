# frozen_string_literal: true

module ToSQLFormatter
  def to_sql
    super.tr('\"', '')
  end
end

ActiveRecord::Relation.class_eval { prepend ToSQLFormatter }
