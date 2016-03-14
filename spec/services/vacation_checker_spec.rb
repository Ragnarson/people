require 'spec_helper'

describe VacationChecker do
  let(:user) { create(:user) }
  let(:vacation) { create(:vacation, eventid: 1, ends_at: Date.today - 1.day, user: user) }
  let!(:checker) { VacationChecker.new(vacation) }

  describe '#check!' do
    it 'deletes expired vacation' do
      expect(checker).to receive(:delete_vacation).with(checker.vacation)
      expect(checker.vacation).to receive(:delete).with(checker.vacation)
      checker.check!
    end
  end
end
