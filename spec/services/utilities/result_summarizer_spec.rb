require 'rails_helper'

module Utilities

  RSpec.describe ResultSummarizer do
    let(:all_eligible) { %i(eligible eligible eligible) }
    let(:all_ineligible) { %i(ineligible ineligible ineligible) }
    let(:all_contrib) { %i(eligible_with_contribution eligible_with_contribution eligible_with_contribution) }
    let(:elig_and_inelig) { %i(eligible ineligible eligible) }
    let(:elig_and_contrib) { %i(eligible eligible_with_contribution eligible_with_contribution) }
    let(:inelig_and_contrib) { %i(ineligible eligible_with_contribution eligible_with_contribution) }
    let(:all_three) { %i(eligible eligible_with_contribution ineligible) }

    subject { described_class.call(results) }

    context 'all eligible' do
      let(:results) { all_eligible }
      it 'returns :eligible' do
        expect(subject).to eq :eligible
      end
    end

    context 'all ineligible' do
      let(:results) { all_ineligible }
      it 'returns :ineligible' do
        expect(subject).to eq :ineligible
      end
    end

    context 'all eligible with contribution' do
      let(:results) { all_contrib }
      it 'returns :eligible_with_contribution' do
        expect(subject).to eq :eligible_with_contribution
      end
    end

    context 'eligble and ineligible mixed' do
      let(:results) { elig_and_inelig }
      it 'returns :partially_eligible' do
        expect(subject).to eq :partially_eligible
      end
    end

    context 'eligble and eligible_with_contribution mixed' do
      let(:results) { elig_and_contrib }
      it 'returns :eligible_with_contribution' do
        expect(subject).to eq :eligible_with_contribution
      end
    end

    context 'ineligble and eligible_with_contribution mixed' do
      let(:results) { inelig_and_contrib }
      it 'returns :partially_eligible' do
        expect(subject).to eq :partially_eligible
      end
    end

    context 'all three' do
      let(:results) { all_three }
      it 'returns :partially_eligible' do
        expect(subject).to eq :partially_eligible
      end
    end
  end
end
