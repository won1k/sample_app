ThinkingSphinx::Index.define :user, :with => :active_record do
  indexes name, :sortable => true
  indexes email, sortable: true
  indexes house, sortable: true

  has author_id, created_at, updated_at
end