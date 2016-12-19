ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body
  indexes author.email, as: :author, sortable: true

  has commentable_id, author_id, created_at, updated_at
end
