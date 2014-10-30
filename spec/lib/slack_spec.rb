require 'spec_helper'
require 'slack'

describe Slack do
  subject { Hrguru::Application.config.slack }

  let(:user) { create(:user, first_name: 'Tony', last_name: 'Montana') }
  let(:member) { create(:membership, user_id: user.id) }
  let(:vacation) { create(:vacation, user_id: user.id) }
  let!(:project) { create(:project, name: 'Project', slug: 'slug') }
  let(:team) { build(:team)}
  before { project.memberships = [member] }

  describe '#slack_project' do
    context 'when project has been added' do
      context 'without end_at, kickoff attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "`Project` has been `added`.")
          subject.project(project, 'added')
        end
      end

      context 'with kickoff attribute' do
        before do
          project.kickoff = Date.today
          project.end_at = nil
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "`Project` has been `added`. Kickoff: `#{Date.today}`.")
          subject.project(project, 'added')
        end
      end

      context 'with end_at attribute' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "`Project` has been `added`. End at: `#{Date.today}`.")
          subject.project(project, 'added')
        end
      end

      context 'with kickoff, end_at attributes' do
        before do
          project.kickoff = Date.today
          project.end_at = 1.week.from_now
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "`Project` has been `added`. Kickoff: `#{Date.today}`, End at: `#{Date.today+7}`.")
          subject.project(project, 'added')
        end
      end

      context 'as potential without kickoff, end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `added`.")
          subject.project(project, 'added')
        end
      end

      context 'as potential with kickoff attributes' do
        before do
          project.kickoff = Date.today
          project.end_at = nil
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `added`. Kickoff: `#{Date.today}`.")
          subject.project(project, 'added')
        end
      end

      context 'as potential with end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `added`. End at: `#{Date.today}`.")
          subject.project(project, 'added')
        end
      end

      context 'as potential with kickoff, end_at attributes' do
        before do
          project.kickoff = Date.today
          project.end_at = 1.week.from_now
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `added`. Kickoff: `#{Date.today}`, End at: `#{Date.today+7}`.")
          subject.project(project, 'added')
        end
      end

      context 'as archived and potential without kickoff, end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
          project.potential = true
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential archived project: `Project` has been `added`.")
          subject.project(project, 'added')
        end
      end

      context 'as archived and potential with end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
          project.potential = true
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential archived project: `Project` has been `added`. End at: `#{Date.today}`.")
          subject.project(project, 'added')
        end
      end

      context 'as archived with end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Archived project: `Project` has been `added`. End at: `#{Date.today}`.")
          subject.project(project, 'added')
        end
      end

      context 'as archived without kickoff, end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Archived project: `Project` has been `added`.")
          subject.project(project, 'added')
        end
      end
    end

    context 'when project has been updated' do
      context 'without end_at, kickoff attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
        end

        it 'sends notification' do
           expect(subject.client).to receive(:notify).with(
            "`Project` has been `updated`.")
           subject.project(project, 'updated')
        end
      end

      context 'with kickoff attribute' do
        before do
          project.kickoff = Date.today
          project.end_at = nil
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "`Project` has been `updated`. Kickoff: `#{Date.today}`.")
          subject.project(project, 'updated')
        end
      end

      context 'with end_at attribute' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "`Project` has been `updated`. End at: `#{Date.today}`.")
          subject.project(project, 'updated')
        end
      end

      context 'with kickoff, end_at attributes' do
        before do
          project.kickoff = Date.today
          project.end_at = 1.week.from_now
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "`Project` has been `updated`. Kickoff: `#{Date.today}`, End at: `#{Date.today+7}`.")
          subject.project(project, 'updated')
        end
      end

      context 'as potential without kickoff, end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `updated`.")
          subject.project(project, 'updated')
        end
      end

      context 'as potential with kickoff attributes' do
        before do
          project.kickoff = Date.today
          project.end_at = nil
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `updated`. Kickoff: `#{Date.today}`.")
          subject.project(project, 'updated')
        end
      end

      context 'as potential with end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `updated`. End at: `#{Date.today}`.")
          subject.project(project, 'updated')
        end
      end

      context 'as potential with kickoff, end_at attributes' do
        before do
          project.kickoff = Date.today
          project.end_at = 1.week.from_now
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `updated`. Kickoff: `#{Date.today}`, End at: `#{Date.today+7}`.")
          subject.project(project, 'updated')
        end
      end

      context 'as archived and potential without kickoff, end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
          project.potential = true
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential archived project: `Project` has been `updated`.")
          subject.project(project, 'updated')
        end
      end

      context 'as archived and potential with end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
          project.potential = true
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential archived project: `Project` has been `updated`. End at: `#{Date.today}`.")
          subject.project(project, 'updated')
        end
      end

      context 'as archived with end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Archived project: `Project` has been `updated`. End at: `#{Date.today}`.")
          subject.project(project, 'updated')
        end
      end

      context 'as archived without kickoff, end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Archived project: `Project` has been `updated`.")
          subject.project(project, 'updated')
        end
      end
    end

    context 'when project has been removed' do
      context 'without end_at, kickoff attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
        end

        it 'sends notification' do
           expect(subject.client).to receive(:notify).with(
            "`Project` has been `removed`.")
          subject.project(project, 'removed')
        end
      end

      context 'with kickoff attribute' do
        before do
          project.kickoff = Date.today
          project.end_at = nil
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "`Project` has been `removed`. Kickoff: `#{Date.today}`.")
          subject.project(project, 'removed')
        end
      end

      context 'with end_at attribute' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "`Project` has been `removed`. End at: `#{Date.today}`.")
          subject.project(project, 'removed')
        end
      end

      context 'with kickoff, end_at attributes' do
        before do
          project.kickoff = Date.today
          project.end_at = 1.week.from_now
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "`Project` has been `removed`. Kickoff: `#{Date.today}`, End at: `#{Date.today+7}`.")
          subject.project(project, 'removed')
        end
      end

      context 'as potential without kickoff, end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `removed`.")
          subject.project(project, 'removed')
        end
      end

      context 'as potential with kickoff attributes' do
        before do
          project.kickoff = Date.today
          project.end_at = nil
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `removed`. Kickoff: `#{Date.today}`.")
          subject.project(project, 'removed')
        end
      end

      context 'as potential with end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `removed`. End at: `#{Date.today}`.")
          subject.project(project, 'removed')
        end
      end

      context 'as potential with kickoff, end_at attributes' do
        before do
          project.kickoff = Date.today
          project.end_at = 1.week.from_now
          project.potential = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential project: `Project` has been `removed`. Kickoff: `#{Date.today}`, End at: `#{Date.today+7}`.")
          subject.project(project, 'removed')
        end
      end

      context 'as archived and potential without kickoff, end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
          project.potential = true
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential archived project: `Project` has been `removed`.")
          subject.project(project, 'removed')
        end
      end

      context 'as archived and potential with end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
          project.potential = true
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Potential archived project: `Project` has been `removed`. End at: `#{Date.today}`.")
          subject.project(project, 'removed')
        end
      end

      context 'as archived with end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = Date.today
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Archived project: `Project` has been `removed`. End at: `#{Date.today}`.")
          subject.project(project, 'removed')
        end
      end

      context 'as archived without kickoff, end_at attributes' do
        before do
          project.kickoff = nil
          project.end_at = nil
          project.archived = true
        end

        it 'sends notification' do
          expect(subject.client).to receive(:notify).with(
            "Archived project: `Project` has been `removed`.")
          subject.project(project, 'removed')
        end
      end
    end

    describe '#slack_member' do
      context 'when member' do
        context 'has been added to project' do
          it 'sends notification' do
            expect(subject.client).to receive(:notify).with(
              "`Tony Montana` has been `added` to project: `Project`.")
            subject.membership(member, 'added')
          end
        end

        context 'has been removed' do
          it 'sends notification' do
            expect(subject.client).to receive(:notify).with(
              "`Tony Montana` has been `removed` from project: `Project`.")
            subject.membership(member, 'removed')
          end
        end
      end
    end

    describe '#slack_vacation' do
      context 'when vacation' do
        context 'has been added' do
          it 'sends notification' do
            expect(subject.client).to receive(:notify).with(
              "Vacation has been `added`. `Tony Montana`: `#{Date.today-1.day}... #{Date.today+6.days}`.")
            subject.vacation(vacation, 'added')
          end
        end

        context 'has been updated' do
          it 'sends notification' do
            expect(subject.client).to receive(:notify).with(
              "Vacation has been `updated`. `Tony Montana`: `#{Date.today-1.day}... #{Date.today+6.days}`.")
            subject.vacation(vacation, 'updated')
          end
        end
      end
    end

    describe '#slack_team' do
      context 'when team' do
        context 'has been added' do
          it 'sends notification' do
            expect(subject.client).to receive(:notify).with(
              "Team: `super team` has been `added`.")
            subject.team(team, 'added')
          end
        end

        context 'has been updated' do
          it 'sends notification' do
            expect(subject.client).to receive(:notify).with(
              "Team: `super team` has been `updated`.")
            subject.team(team, 'updated')
          end
        end

        context 'has been removed' do
          it 'sends notification' do
            expect(subject.client).to receive(:notify).with(
              "Team: `super team` has been `removed`.")
            subject.team(team, 'removed')
          end
        end
      end
    end

    describe '#slack_project_checker' do
      context 'when method has been called' do
        context 'with finished action' do
        before { project.end_at = Date.today }

          it 'sends notification' do
            expect(subject.client).to receive(:notify).with(
              "`Project` will be `finished` at: `#{Date.today}`.")
            subject.project_checker(project, 'finished')
          end
        end

        context 'with started action' do
          context 'when project is not archived' do
          before { project.kickoff = Date.today }

            it 'sends notification' do
              expect(subject.client).to receive(:notify).with(
                "`Project` will be `started` at: `#{Date.today}`.")
              subject.project_checker(project, 'started')
            end
          end
        end
      end
    end

    describe '#slack_member_checker' do
      context 'when method has been called' do
        context 'with finish action' do
        before { member.ends_at = Date.today }

          it 'sends notification' do
            expect(subject.client).to receive(:notify).with(
              "Project: `Tony Montana` will `finish` work at: `#{Date.today}`.")
            subject.member_checker(project, member, 'finish')
          end
        end

        context 'with start action' do
        before { member.starts_at = Date.today }

          it 'sends notification' do
            expect(subject.client).to receive(:notify).with(
              "Project: `Tony Montana` will `start` work at: `#{Date.today}`.")
            subject.member_checker(project, member, 'start')
          end
        end
      end
    end
  end
end
