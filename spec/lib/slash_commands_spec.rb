require 'spec_helper'
include SlashCommands

describe SlashCommands do

  let!(:user) do
    create(:user, first_name: 'Tony', last_name: 'Montana', email: 'tm@ex.com',
      phone: '123', available: 'false')
  end
  let(:sec_user) { create(:user, first_name: 'John', last_name: 'Doe') }
  let(:member) { create(:membership, user_id: user.id) }
  let!(:project) { create(:project, name: 'Project', slug: 'slug', end_at: Date.today) }
  let(:team) { create(:team, name: 'AA') }

  describe '#execute' do
    context 'user checks project' do
      it 'calls #project' do
        expect(subject).to receive(:project).with('project', '@test')
        subject.execute('project', '@test')
      end
    end

    context 'user checks contact' do
      it 'calls #contact' do
        expect(subject).to receive(:contact).with('contact', '@test')
        subject.execute('contact', '@test')
      end
    end

    context 'user checks team' do
      it 'calls #team' do
        expect(subject).to receive(:team).with('team', '@test')
        subject.execute('team', '@test')
      end
    end

    context 'user checks vacation' do
      it 'calls #vacation' do
        expect(subject).to receive(:vacation).with('vacation', '@test')
        subject.execute('vacation', '@test')
      end
    end

    context 'user checks member' do
      it 'calls #member' do
        expect(subject).to receive(:member).with('member', '@test')
        subject.execute('member', '@test')
      end
    end

    context 'user checks available user' do
      it 'calls #available' do
        expect(subject).to receive(:available).with('available', '@test')
        subject.execute('available', '@test')
      end
    end
  end

  describe '#project' do
    context 'with valid parameter' do
      context 'when lowercase' do
        it 'sends notification' do
          expect(SLACK.client).to receive(:notify).with(
            "Project: `Project`:  End at: `#{Date.today}`. ", "@test")
          subject.send(:project, 'project project', '@test')
        end
      end

      context 'when uppercase' do
        it 'sends notification' do
          expect(SLACK.client).to receive(:notify).with(
            "Project: `Project`:  End at: `#{Date.today}`. ", "@test")
          subject.send(:project, 'project Project', '@test')
        end
      end
    end

    context 'with invalid parameter' do
      it 'calls #not_found' do
        expect(subject).to receive(:not_found).with('Project', '@test')
        subject.send(:project, 'project ccc', '@test')
      end
    end
  end

  describe '#contact' do
    context 'with valid parameter' do
      it 'sends notification' do
        expect(SLACK.client).to receive(:notify).with(
          "`Montana Tony`:\nPhone: `123` \nEmail: `tm@ex.com`", "@test")
        subject.send(:contact, 'contact Tony Montana', '@test')
      end
    end

    context 'with invalid parameter' do
      it 'calls #not_found' do
        expect(subject).to receive(:not_found).with('Contact', '@test')
        subject.send(:contact, 'contact', '@test')
      end
    end
  end

  describe '#team' do
    context 'with valid parameter' do
      before do
        team.leader = sec_user
        team.users = [user]
      end
      context 'when lowercase' do
        it 'sends notification' do
          expect(SLACK.client).to receive(:notify).with(
            "Team `AA`:\nLeader: `Doe John` \nTeammates: `Montana Tony`", "@test")
          subject.send(:team, 'team aa', '@test')
        end
      end

      context 'when uppercase' do
        it 'sends notification' do
          expect(SLACK.client).to receive(:notify).with(
            "Team `AA`:\nLeader: `Doe John` \nTeammates: `Montana Tony`", "@test")
          subject.send(:team, 'team AA', '@test')
        end
      end
    end

    context 'with invalid parameter' do
      it 'calls #not_found' do
        expect(subject).to receive(:not_found).with('Team', '@test')
        subject.send(:team, 'team', '@test')
      end
    end
  end

  describe '#member' do
    context 'with valid parameter' do
      before { project.memberships = [member] }
      it 'sends notification' do
        expect(SLACK.client).to receive(:notify).with(
          "Tony Montana's project(s): `Project`.", "@test")
        subject.send(:member, 'member Tony Montana', '@test')
      end
    end

    context 'with invalid parameter' do
      it 'calls #not_found' do
        expect(subject).to receive(:not_found).with('Member', '@test')
        subject.send(:member, 'member', '@test')
      end
    end
  end

  describe '#vacation' do
    context 'with valid parameter' do
      let!(:vacation) { create(:vacation, starts_at: Date.today, ends_at: Date.today + 7, user: user) }
      let(:second_vacation) { create(:vacation, user: user) }

      it 'sends notification' do
        expect(SLACK.client).to receive(:notify).with(
          "Vacation: `Tony Montana` - `#{Date.today}... #{Date.today + 7}`.", "@test")
        subject.send(:vacation, 'vacation Tony Montana', '@test')
      end

      it 'sends notification for each vacation' do
        second_vacation
        expect(SLACK.client).to receive(:notify).twice
        subject.send(:vacation, 'vacation Tony Montana', '@test')
      end
    end

    context 'with invalid parameter' do
      it 'calls #not_found' do
        expect(subject).to receive(:not_found).with('Vacation', '@test')
        subject.send(:vacation, 'vacation', '@test')
      end
    end
  end

  describe '#available' do
    context 'when available users exist' do
      before do
        user.update_attributes(available: true)
        sec_user.update_attributes(available: true)
      end
      it 'sends notification' do
        expect(SLACK.client).to receive(:notify).with(
          "Available users: `Tony Montana, John Doe`.", "@test")
        subject.send(:available, 'available', '@test')
      end
    end

    context 'when available users not exist' do
      it 'calls #not_found' do
        expect(subject).to receive(:not_found).with('Available users', '@test')
        subject.send(:available, 'available', '@test')
      end
    end
  end

  describe '#not_found' do
    it 'sends notification' do
      expect(SLACK.client).to receive(:notify).with(
        "`Available was not found.`", "@test")
      subject.send(:not_found, 'Available', '@test')
    end
  end
end
