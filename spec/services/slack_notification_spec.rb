require 'spec_helper'

describe SlackNotification do
  subject { Hrguru::Application.config.slack }

  let(:user) { create(:user, first_name: 'Tony', last_name: 'Montana') }
  let(:sec_user) { create(:user, first_name: 'John', last_name: 'Doe') }
  let(:member) { create(:membership, user_id: user.id) }
  let(:sec_member) { create(:membership, user_id: sec_user.id) }
  let(:project) { create(:project, name: 'Project', slug: 'slug') }
  before { project.memberships = [member, sec_member] }

  describe '#notify' do
    context 'when project will be' do
      context 'started a week away' do
        before { project.kickoff = 1.week.from_now }

        it 'sends notification' do
          expect(subject).to receive(:project_checker).with(project, 'started')
          SlackNotification.new(project).notify
        end
      end

      context 'started tomorrow' do
        before { project.kickoff = Date.today+1 }

        it 'sends notification' do
          expect(subject).to receive(:project_checker).with(project, 'started')
          SlackNotification.new(project).notify
        end
      end

      context 'started an other day' do
        before { project.kickoff = Date.today+3 }

        it 'sends notification' do
          expect(subject).not_to receive(:project_checker).with(project, 'started')
          SlackNotification.new(project).notify
        end
      end

      context 'finished a week away' do
        before { project.end_at = 1.week.from_now }

        it 'sends notification' do
          expect(subject).to receive(:project_checker).with(project, 'finished')
          SlackNotification.new(project).notify
        end
      end

      context 'finished tomorrow' do
        before { project.end_at = Date.today+1 }

        it 'sends notification' do
          expect(subject).to receive(:project_checker).with(project, 'finished')
          SlackNotification.new(project).notify
        end
      end

      context 'finished an other day' do
        before { project.end_at = Date.today+3 }

        it 'sends notification' do
          expect(subject).not_to receive(:project_checker).with(project, 'finished')
          SlackNotification.new(project).notify
        end
      end
    end

    context 'when member will' do
      context 'start a week away' do
        before do
          member.starts_at = 1.week.from_now
          sec_member.starts_at = 2.week.from_now
        end

        it 'sends notification' do
          expect(subject).to receive(:member_checker).with(project.name, member, 'start')
          expect(subject).not_to receive(:member_checker).with(project.name, sec_member, 'start')
          SlackNotification.new(project).notify
        end
      end

      context 'start tomorrow' do
        before do
          member.starts_at = 1.day.from_now
          sec_member.starts_at = 2.days.from_now
        end

        it 'sends notification' do
          expect(subject).to receive(:member_checker).with(project.name, member, 'start')
          expect(subject).not_to receive(:member_checker).with(project.name, sec_member, 'start')
          SlackNotification.new(project).notify
        end
      end

      context 'start an other day' do
        before do
          member.starts_at = 3.days.from_now
          sec_member.starts_at = 2.days.from_now
        end

        it 'sends notification' do
          expect(subject).not_to receive(:member_checker).with(project.name, member, 'start')
          expect(subject).not_to receive(:member_checker).with(project.name, sec_member, 'start')
          SlackNotification.new(project).notify
        end
      end

      context 'finish a week away' do
        before do
          member.ends_at = 1.week.from_now
          sec_member.ends_at = 2.days.from_now
        end

        it 'sends notification' do
          expect(subject).to receive(:member_checker).with(project.name, member, 'finish')
          expect(subject).not_to receive(:member_checker).with(project.name, sec_member, 'finish')
          SlackNotification.new(project).notify
        end
      end

      context 'finish tomorrow' do
        before do
          member.ends_at = 1.day.from_now
          sec_member.ends_at = 2.days.from_now
        end

        it 'sends notification' do
          expect(subject).to receive(:member_checker).with(project.name, member, 'finish')
          expect(subject).not_to receive(:member_checker).with(project.name, sec_member, 'finish')
          SlackNotification.new(project).notify
        end
      end

      context 'finish an other day' do
        before do
          member.ends_at = 3.days.from_now
          sec_member.ends_at = 2.days.from_now
        end

        it 'sends notification' do
          expect(subject).not_to receive(:member_checker).with(project.name, member, 'finish')
          expect(subject).not_to receive(:member_checker).with(project.name, sec_member, 'finish')
          SlackNotification.new(project).notify
        end
      end
    end
  end
end
