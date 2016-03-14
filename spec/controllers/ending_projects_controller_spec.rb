require 'spec_helper'

describe EndingProjectsController do
  let!(:first_project) { create(:project, end_at: 7.days.from_now, name: 'first') }
  let!(:second_project) { create(:project, end_at: 65.days.from_now, name: 'sec') }
  let!(:old_project) { create(:project, end_at: 7.days.ago) }
  let!(:first_member) { create(:membership,
    ends_at: 7.days.from_now, project_id: first_project.id) }
  let!(:second_member) { create(:membership,
    ends_at: nil, project_id: second_project.id) }
  before(:each) do
    admin = create(:admin_role)
    sign_in create(:user, admin_role_id: admin.id)
  end

  describe '#index' do
    render_views
    before { get :index }

    it 'responds successfully with an HTTP 200 status code' do
      expect(response).to be_success
    end

    it 'displays projects on view' do
      expect(response.body).to match /first/
    end

    it 'displays proper number of projects' do
      expect(controller.projects.count).to eq 1
    end

    it 'displays memberships names on view' do
      expect(response.body).to match /#{first_member.user.decorate.name}/
    end
  end
end
