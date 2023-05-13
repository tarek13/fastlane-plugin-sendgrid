describe Fastlane::Actions::SendgridAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The sendgrid plugin is working!")

      Fastlane::Actions::SendgridAction.run(nil)
    end
  end
end
