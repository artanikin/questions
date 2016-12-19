ThinkingSphinx::Index.define :user, with: :active_record do
  indexes email
  indexes questions.title, as: :questions_title, sortable: true
  indexes questions.body, as: :questions_body
  indexes answers.body, as: :answers
end
