require 'spec_helper'

describe VacationCheckerJob do
  let(:job) { VacationCheckerJob.new }
  let(:user) { create(:user) }
  let!(:vacation) { create(:vacation, eventid: 1, ends_at: Date.today - 1.day, user: user) }

  describe '#perform' do
    it 'runs check on VacationChecker' do
      checker = double
      expect(VacationChecker).to receive(:new).with(vacation).and_return(checker)
      expect(checker).to receive(:check!)
      job.perform(vacation)
    end
  end
end
