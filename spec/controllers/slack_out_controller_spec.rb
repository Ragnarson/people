require 'spec_helper'
include SlashCommands

describe SlackOutController do
  describe '#check_command' do
    context 'when token is valid' do
      it 'executes method' do
        controller.stub(:params).and_return({:token => '132456',
          :text=>'project', :user_name=>'test'}.with_indifferent_access)
        expect(controller).to receive(:execute).with('project','@test')
        post :check_command
      end
    end
    context 'when token is invalid' do
      it 'renders error' do
        controller.stub(:params).and_return({:token => '13254'}.with_indifferent_access)
        post :check_command
        expect(response.body).to eq('No authentication!')
      end
    end
  end
end
