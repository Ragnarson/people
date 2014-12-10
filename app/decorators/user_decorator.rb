class UserDecorator < Draper::Decorator
  decorates :user
  decorates_association :memberships, scope: :only_active
  delegate_all
  CSV_HEADERS = ['Last Name', 'First Name', 'Position', 'Location', 'Projects']

  def as_row
    [model.last_name, model.first_name, model.role, model.location]
  end

  def project_names
    model.memberships.map { |m| m.project.name}.uniq
  end

  def name
    "#{last_name} #{first_name}"
  end

  def link
    h.link_to name, object
  end

  def project_link
    h.link_to(project.name, project) if project
  end

  def gravatar_url(size = 80)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "https://www.gravatar.com/avatar/#{gravatar_id}?size=#{size}"
  end

  def gravatar_image(options = {})
    size = options.delete(:size)
    h.image_tag gravatar_url(size), options
  end

  def days_in_current_team
    team_join_time.nil? ? 0 : (DateTime.now - team_join_time).to_i
  end

  def github_link(options = {})
    if github_connected?
      h.link_to "https://github.com/#{gh_nick}", title: gh_nick do
        options[:icon] ? h.fa_icon("github-alt") : gh_nick
      end
    end
  end

  def skype_link
    if skype?
      h.link_to "skype:#{skype}?userinfo", title: skype do
        h.fa_icon("skype")
      end
    end
  end

  def info
    pr = Membership.where(user_id: user.id).map {|m| m.project.name}.join(', ')
    sk = skype.present? ? skype : 'No skype'
    ph = phone.present? ? phone : 'No phone'
    name + "\n" + ph + "\n" + email + "\n" + sk + "\n" + pr
  end

  def role?(value)
    role == value
  end

  def contact_details
    p = phone.presence ? "\nPhone: `#{phone}`" : ""
    e = email.presence ? " \nEmail: `#{email}`" : ""
    s = skype.presence ? " \nSkype: `#{skype}`" : ""
    p + e + s
  end
end
