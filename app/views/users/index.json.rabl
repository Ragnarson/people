collection users

extends "users/base"

node(:gravatar) { |user| user.gravatar_image(size: 40) }
node(:github) { |user| user.github_link(icon: true) }
node(:skype) { |user| user.skype_link }
node(:projects) { |user| user.current_projects }
node(:membership) { |user| user.last_membership }
node(:has_project) { |user| user.has_current_projects? }
node(:has_next_project) { |user| user.has_next_projects? }
node(:has_potential_project) { |user| user.has_potential_projects? }
node(:next_projects) { |user| user.next_projects }
node(:potential_projects) { |user| user.potential_projects }
