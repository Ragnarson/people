require "spec_helper"
include Calendar

describe "Vacations", js: true do
  let!(:admin) { create(:admin_role) }
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe "create" do
    let(:starts) { Date.today + 1.week }
    let(:ends) { Date.today + 2.weeks }
    let(:vacation) { create(:vacation, user: user) }

    before do
      allow_any_instance_of(VacationsController).to receive(:export_vacation).and_return(true)
    end

    it "user can add new vacation" do
      click_link "Vacations"
      click_link "New Vacation"
      fill_in "Starts at", with: starts.to_s
      fill_in "Ends at", with: ends.to_s
      click_button "Save"

      expect(page).to have_content starts
      expect(user.vacations.size).to eq 1
      expect(page).to have_content "Vacation created!"
    end

    it "user can add more than one vacation" do
      vacation
      click_link "Vacations"
      click_link "New Vacation"
      fill_in "Starts at", with: (starts + 1.month).to_s
      fill_in "Ends at", with: (ends + 1.month).to_s
      click_button "Save"

      expect(page).to have_content (starts + 1.month).to_s
      expect(user.vacations.size).to eq 2
      expect(page).to have_content "Vacation created!"
    end
  end

  describe "edit" do
    let!(:vacation) { create(:vacation, user: user, starts_at: (Date.today + 1.week).to_s) }

    it "user can edit their vacations" do
      expect(user.vacations.size).to eq 1
      click_link "Vacations"
      expect(page).to have_content (Date.today + 1.week).to_s
      click_link "Edit"
      fill_in "Starts at", with: (Date.today + 2.weeks).to_s
      click_button "Save"

      expect(page).to have_content (Date.today + 2.weeks).to_s
      expect(user.vacations.size).to eq 1
      expect(page).to have_content "Vacation updated!"
    end
  end

  describe "delete" do
    let(:other_user) { create(:user) }
    let!(:other_vacation) { create(:vacation, user: other_user) }
    let!(:vacation) { create(:vacation, user: user) }

    it "user can delete their vacations" do
      expect(Vacation.count).to eq 2
      expect(user.vacations.size).to eq 1
      click_link "Vacations"
      click_link "Delete"
      expect(user.vacations.size).to eq 0
      expect(page).to have_content "Vacation destroyd!"
    end
  end
end
