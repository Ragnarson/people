attributes :id, :name, :email, :role, :employment, :phone, :location, :contract_type, :archived, :abilities
node(:info) { |user| user.info }

