attributes :id, :name, :email, :role, :employment, :phone, :location, :contract_type, :archived
node(:info) { |user| user.info }

