require "spec_helper"

describe "User sign up", js: true do
  let(:senior_role) { create(:admin_role) }
  let(:user) { create(:user, admin_role_id: senior_role.id) }
  let!(:dev_user) { create(:user, first_name: 'Developer Daisy', admin_role_id: senior_role.id) }

  before(:each) do
    page.set_rack_session 'warden.user.user.key' => User.serialize_into_session(user).unshift('User')
    create(:project, name: "test")   
    create(:project, name: "zztop")
    visit '/projects'
  end

  describe 'search form' do
    it "searches for 'test' in projects" do
      fill_in 'search', :with => 'test'
      click_button 'search'
      expect(page).to have_text('test')
      page.should have_no_content('zztop')
    end

    it 'searches empty imput' do
      fill_in 'search', :with => ""
      click_button 'search'
      expect(page).to have_text('zztop')
      expect(page).to have_text('test')
    end
  end
end
