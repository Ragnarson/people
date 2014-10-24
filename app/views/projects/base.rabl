attributes :id, :name, :archived, :potential, :end_at, :internal

child :notes do
  extends 'notes/base'
end
