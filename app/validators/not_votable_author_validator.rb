class NotVotableAuthorValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.votable && value == record.votable.author_id
      record.errors[attribute] << (
        options[:message] || "You can not vote for your #{record.votable.model_name.singular}")
    end
  end
end
