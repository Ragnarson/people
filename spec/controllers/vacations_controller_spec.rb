require 'spec_helper'

describe VacationsController do
  let!(:user) { create(:user, first_name: 'John', last_name: 'Doe',
    email: 'johndoe@example.com') }

  before(:each) do
    AppConfig.stub(:calendar_id).and_return('1')
    admin = create(:admin_role)
    sign_in create(:user, oauth_token: '132', admin_role_id: admin.id)
  end

  describe '#index' do
    let!(:vacation) { create(:vacation, user: user) }
    render_views

    it 'responds successfully with an HTTP status code' do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'exposes vacation' do
      get :index
      expect(controller.all_vacations.count).to eq 1
    end

    it 'displays vacations on view' do
      get :index
      expect(response.body).to have_content(vacation.user.first_name)
      expect(response.body).to have_content(vacation.starts_at)
    end
  end

  describe '#create' do
    context 'with valid attributes' do
      subject { attributes_for(:vacation, starts_at: "2014-09-02", ends_at: "2014-09-10", user: user) }

      it 'creates a new vacation' do
        expect(controller).to receive(:export_vacation)

        expect{
         post :create, user_id: user.id, vacation: subject
        }.to change(Vacation, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      subject { attributes_for(:vacation, starts_at: nil, user: user) }

      it 'does not save a new vacation' do
        expect{
         post :create, user_id: user.id, vacation: subject
        }.not_to change(Vacation, :count)
      end

      it 're-renders a new method' do
        post :create, user_id: user.id, vacation: subject
        expect(response).to render_template :new
      end
    end
  end

  describe '#update' do
    let!(:vacation) { create(:vacation, starts_at: "2014-09-02", ends_at: "2014-09-09", user: user) }

    context 'with valid attributes' do
      it 'changes attributes of vacation' do
        put :update, user_id: vacation.user.id, id: vacation.id, vacation: attributes_for(:vacation, ends_at: "2014-09-10")
        vacation.reload
        expect(vacation.ends_at).to eq(("2014-09-10").to_date)
      end
    end

    context 'with invalid attributes' do
      it 'does not change attributes of vacation' do
        put :update, user_id: vacation.user.id, id: vacation.id, vacation: attributes_for(:vacation, ends_at: nil, id: vacation.id)
        vacation.reload
        expect(vacation.ends_at).to eq(("2014-09-09").to_date)
      end

      it 're-renders the edit method' do
        put :update, user_id: vacation.user.id, id: vacation.id, vacation: attributes_for(:vacation, ends_at: nil)
        expect(response).to render_template :edit
      end
    end
  end

  describe '#delete' do
    let!(:vacation) { create(:vacation, user: user) }

    it 'deletes the vacation' do
      expect(Vacation.count).to eq 1
      expect{
        delete :destroy, user_id: user.id, id: vacation.id
      }.to change(Vacation, :count).by(-1)
    end
  end
end
