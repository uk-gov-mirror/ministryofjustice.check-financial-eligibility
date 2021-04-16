require 'rails_helper'

module Utilities
  RSpec.describe Utilities::EligibilitiesCreator do
    describe '.call' do
      let(:assessment) do
        create :assessment,
               :with_capital_summary,
               :with_disposable_income_summary,
               :with_gross_income_summary,
               proceeding_type_codes: %w[DA001 SE013]
      end
      let(:capital_summary) { assessment.capital_summary }
      let(:gross_income_summary) { assessment.gross_income_summary }
      let(:disposable_income_summary) { assessment.disposable_income_summary }

      subject { described_class.call(assessment) }

      around do |example|
        travel_to Date.new(2021, 4, 21)
        example.run
        travel_back
      end

      it 'creates all the records' do
        expect { subject }.to change { Eligibility::Base.count }.by(6)
      end

      context 'capital eligibilities' do
        it 'creates Eligibility::Capital records with the correct values' do
          subject

          elig = capital_summary.eligibilities.find_by(proceeding_type_code: 'DA001')
          expect(elig).to be_instance_of(Eligibility::Capital)
          expect(elig.lower_threshold).to eq 3_000.0
          expect(elig.upper_threshold).to eq 999_999_999_999.0
          expect(elig.assessment_result).to eq 'pending'

          elig = capital_summary.eligibilities.find_by(proceeding_type_code: 'SE013')
          expect(elig).to be_instance_of(Eligibility::Capital)
          expect(elig.lower_threshold).to eq 3_000.0
          expect(elig.upper_threshold).to eq 8_000.0
          expect(elig.assessment_result).to eq 'pending'
        end
      end

      context 'gross_income eligibilities' do
        it 'creates Eligibility::GrossIncome records with the correct values' do
          subject

          elig = gross_income_summary.eligibilities.find_by(proceeding_type_code: 'DA001')
          expect(elig).to be_instance_of(Eligibility::GrossIncome)
          expect(elig.lower_threshold).to be_nil
          expect(elig.upper_threshold).to eq 999_999_999_999.0
          expect(elig.assessment_result).to eq 'pending'

          elig = gross_income_summary.eligibilities.find_by(proceeding_type_code: 'SE013')
          expect(elig).to be_instance_of(Eligibility::GrossIncome)
          expect(elig.lower_threshold).to be_nil
          expect(elig.upper_threshold).to eq 2_657.0
          expect(elig.assessment_result).to eq 'pending'
        end
      end

      context 'disposable_income eligibilities' do
        it 'creates Eligibility::GrossIncome records with the correct values' do
          subject

          elig = disposable_income_summary.eligibilities.find_by(proceeding_type_code: 'DA001')
          expect(elig).to be_instance_of(Eligibility::DisposableIncome)
          expect(elig.lower_threshold).to eq 315.0
          expect(elig.upper_threshold).to eq 999_999_999_999.0
          expect(elig.assessment_result).to eq 'pending'

          elig = disposable_income_summary.eligibilities.find_by(proceeding_type_code: 'SE013')
          expect(elig).to be_instance_of(Eligibility::DisposableIncome)
          expect(elig.lower_threshold).to eq 315.0
          expect(elig.upper_threshold).to eq 733.0
          expect(elig.assessment_result).to eq 'pending'
        end
      end
    end
  end
end
