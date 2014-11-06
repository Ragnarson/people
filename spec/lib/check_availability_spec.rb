require 'spec_helper'
include CheckAvailability

describe CheckAvailability do
  let(:user) { create(:user) }
  let(:sec_user) { create(:user) }
  let!(:project) { create(:project, end_at: nil) }
  let(:member) do
    create(:membership, user_id: user.id, billable: true, ends_at: Date.today, project: project)
  end

  describe '#available_at?' do
    context 'user who is available now' do
      before do
        create(:membership, user: user, billable: true, ends_at: 4.day.from_now, project: project)
        create(:membership,
          user: sec_user, billable: true, ends_at: 18.day.from_now, project: project)
      end

      it 'returns true' do
        expect(subject.available_at?(user, Time.now)).to be_true
      end

      it 'returns false' do
        expect(subject.available_at?(sec_user, Time.now)).to be_false
      end
    end

    context 'user who is available for 3 weeks' do
      before do
        create(:membership, user: user, billable: true, ends_at: 25.day.from_now, project: project)
        create(:membership,
          user: sec_user, billable: true, ends_at: 36.day.from_now, project: project)
      end

      it 'returns true' do
        expect(subject.available_at?(user, 21.days.from_now)).to be_true
      end

      it 'returns false' do
        expect(subject.available_at?(sec_user, 21.days.from_now)).to be_false
      end
    end

    context 'user who is available for 1 month' do
      before do
        create(:membership, user: user, billable: true, ends_at: 35.day.from_now, project: project)
        create(:membership,
          user: sec_user, billable: true, ends_at: 46.day.from_now, project: project)
      end

      it 'returns true' do
        expect(subject.available_at?(user, 1.month.from_now)).to be_true
      end

      it 'returns false' do
        expect(subject.available_at?(sec_user, 1.month.from_now)).to be_false
      end
    end

    context 'user who is available for 2 month' do
      before do
        create(:membership,
          user: user, billable: true, ends_at: 2.months.from_now, project: project)
        create(:membership,
          user: sec_user, billable: true, ends_at: 2.months.from_now + 15.days, project: project)
      end

      it 'returns true' do
        expect(subject.available_at?(user, 2.months.from_now)).to be_true
      end

      it 'returns false' do
        expect(subject.available_at?(sec_user, 2.months.from_now)).to be_false
      end
    end
  end
end
