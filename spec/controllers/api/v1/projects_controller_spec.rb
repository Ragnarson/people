require 'spec_helper'
describe Api::V1::ProjectsController do
  render_views
  before do
    controller.class.skip_before_filter :authenticate_api!
  end

  let!(:project) { create(:project) }
  let(:project_keys) { %w(name archived potential slug) }

  describe "GET #index" do

    before do
      get :index, format: :json
      @json_response = JSON.parse(response.body)
    end

    it "returns 200 code" do
      expect( response.status ).to eq 200
    end

    it "contains current_week fields" do
      expect(@json_response.first.keys).to eq(project_keys)
    end
  end
end
