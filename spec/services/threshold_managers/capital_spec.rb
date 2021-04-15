require 'rails_helper'

module ThresholdManagers
  RSpec.describe Capital do

    describe '.call' do
      around do |example|
        travel_to Date.new(2021, 4, 15)
        example.run
        travel_back
      end

      let(:assessment) { create :assessment, :with_capital_summary, proceeding_type_codes: codes }
      let(:summary) { assessment.capital_summary }

      subject { described_class.call(summary) }

      context 'domestic abuse' do
        let(:codes) { ['DA001'] }
        it 'creates eligibility record with infinite upper limit' do
          expect{subject}.to change {Eligibility::Capital.count}.by(1)
          elig = Eligibility::Capital.first
          expect(elig.parent_id).to eq summary.id
          expect(elig.proceeding_type_code).to eq 'DA001'
          expect(elig.upper_threshold).to eq 999_999_999_999.0
          expect(elig.lower_threshold).to eq 3_000.0
          expect(elig.assessment_result).to eq 'pending'
        end
      end

      context 'section 8' do
        let(:codes) { ['SE014'] }
        it 'creates eligibility record with standard upper limit' do
          expect{subject}.to change {Eligibility::Capital.count}.by(1)
          elig = Eligibility::Capital.first
          expect(elig.parent_id).to eq summary.id
          expect(elig.proceeding_type_code).to eq 'SE014'
          expect(elig.upper_threshold).to eq 8_000.0
          expect(elig.lower_threshold).to eq 3_000.0
          expect(elig.assessment_result).to eq 'pending'
        end
      end

      context 'both domestic abuse and section 8' do
        let(:codes) { %w(DA001 SE003 SE014) }
        it 'creates 3 eligibility records' do
          expect{subject}.to change {Eligibility::Capital.count}.by(3)
        end
      end
    end
  end
end

