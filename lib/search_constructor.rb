# Construct an ActiveRecord query based on tokenized string input.
class SearchConstructor

  def self.construct(model, fields, query_tokens)
    query = model

    query_tokens.each do |token|
      field_query_string = ''
      exclude_token = token.start_with?('-') || token.start_with?('NOT ')
      query_param = exclude_token ? 
          "%#{ActiveRecord::Base.sanitize_sql_like(token.sub(/(NOT |-)/, ''))}%"
        : "%#{ActiveRecord::Base.sanitize_sql_like(token)}%"

      fields.each_with_index do |field, i|
        # The first field shouldn't have a "or", just the field query.
        # Subsequent fields need to be joined with "or".
        # If it's a NOT term, it should be joined with "and" instead.
        if i == 0
          if exclude_token
            field_query_string << "#{field} NOT LIKE ?"
          else
            field_query_string << "#{field} LIKE ?"
          end
        else
          if exclude_token
            field_query_string << " AND #{field} NOT LIKE ?"
          else
            field_query_string << " OR #{field} LIKE ?"
          end
        end
      end  # fields

      query = query.where(field_query_string, *([query_param] * fields.count))
    end  # tokens

    query
  end
end
