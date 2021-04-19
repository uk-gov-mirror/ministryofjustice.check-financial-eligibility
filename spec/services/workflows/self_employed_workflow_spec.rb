require 'rails_helper'

module Workflows
  RSpec.describe SelfEmployedWorkflow do
    describe '# call' do
      let(:assessment) { double Assessment }
      it 'raises' do
        expect {
          described_class.call(assessment)
        }.to raise_error RuntimeError, 'Not yet implemented: Check Fincancial Base service currently does not handle self-employed applicants'
      end
    end
  end
end
