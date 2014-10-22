require "spec_helper"

describe "User sign up", js: true do
  let(:senior_role) { create(:admin_role) }
  let(:user) { create(:user, admin_role_id: senior_role.id) }
  let!(:dev_user) { create(:user, first_name: 'Developer Daisy', admin_role_id: senior_role.id) }

  before(:each) do
    page.set_rack_session 'warden.user.user.key' => User.serialize_into_session(user).unshift('User')
    create(:project, name: 'test')
    create(:membership)
  end

  it "return user in membership with contact icons" do
    visit '/memberships'
    expect(page).to have_css('div.icons')
  end
end
