require 'spec_helper'
require 'slack_notifications_callback_support'

describe SlackNotificationsCallbackSupport do
  let!(:user) { create(:user) }
  let(:member) { create(:membership, user_id: user.id) }
  let!(:project) { create(:project) }
  let(:team) { create(:team) }
  let(:vacation) { create(:vacation) }

  describe '#create' do
    context 'when user' do
      context 'creates a new project' do
        it 'calls after_create' do
          p = Project.new(name: 'First Project')
          expect(p).to receive(:create_msg)
          p.save(validate: false)
        end
      end

      context 'creates a new membership' do
        it 'calls after_create' do
          m = Membership.new(user_id: user.id, project_id: project.id)
          expect(m).to receive(:create_msg)
          m.save(validate: false)
        end
      end

      context 'creates a new team' do
        it 'calls after_create' do
          t = Team.new
          expect(t).to receive(:create_msg)
          t.save(validate: false)
        end
      end

      context 'creates a new vacation' do
        it 'calls after_create' do
          v = Vacation.new
          expect(v).to receive(:create_msg)
          v.save(validate: false)
        end
      end
    end
  end

  describe '#update' do
    context 'when user' do
      context 'updates a project' do
        it 'calls after_update' do
          expect(project).to receive(:update_msg)
          project.update
        end
      end

      context 'updates a membership' do
        it 'calls after_update' do
          expect(member).to receive(:update_msg)
          member.update
        end
      end

      context 'updates a team' do
        it 'calls after_update' do
          expect(team).to receive(:update_msg)
          team.update
        end
      end

      context 'updates a vacation' do
        it 'calls after_update' do
          expect(vacation).to receive(:update_msg)
          vacation.update
        end
      end
    end
  end

  describe '#destroy' do
    context 'when user' do
      context 'removes a project' do
        it 'calls before_destroy' do
          expect(project).to receive(:destroy_msg)
          project.destroy
        end
      end

      context 'removes a membership' do
        it 'calls after_create' do
          expect(member).to receive(:destroy_msg)
          member.destroy
        end
      end

      context 'removes a team' do
        it 'calls after_create' do
          expect(team).to receive(:destroy_msg)
          team.destroy
        end
      end

      context 'removes a vacation' do
        it 'calls after_create' do
          expect(vacation).to receive(:destroy_msg)
          vacation.destroy
        end
      end
    end
  end

  describe '#create_msg' do
    before do
      project.name = 'New'
      project.kickoff = Date.today
      project.end_at = Date.today + 7
    end

    it 'sends slack notification' do
      expect(SLACK.client).to receive(:notify).with(
        "Project: `New` has been `added`. Kickoff: `#{Date.today}`. End at: `#{Date.today + 7}`.")
      project.send(:create_msg)
    end
  end

  describe '#update_msg' do
    context 'when user changed something' do
      before do
        project.name = 'Old'
        project.kickoff = Date.today
        project.end_at = Date.today + 7
      end

      it 'sends slack notification' do
        expect(SLACK.client).to receive(:notify).with(
          "Project: `Old` has been `updated`. Kickoff: `#{Date.today}`. "\
          "End at: `#{Date.today + 7}`.")
        project.send(:update_msg)
      end
    end

    context 'when user changed nothing' do
      it 'doesnt send anything' do
        project.send(:update_msg)
        expect(project.changed?).to be_false
      end
    end
  end

  describe '#destroy_msg' do
    before do
      project.name = 'Old'
      project.kickoff = nil
      project.end_at = nil
    end

    it 'sends slack notification' do
      expect(SLACK.client).to receive(:notify).with(
        "Project: `Old` has been `removed`.")
      project.send(:destroy_msg)
    end
  end
end
