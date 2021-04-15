class GrossIncomeSummary < ApplicationRecord
  belongs_to :assessment
  has_many :state_benefits, dependent: :destroy
  has_many :other_income_sources, dependent: :destroy
  has_many :irregular_income_payments, dependent: :destroy
  has_many :cash_transaction_categories, dependent: :destroy
  has_many :eligibilities, class_name: 'Eligibility::GrossIncome', foreign_key: :parent_id, dependent: :destroy

  def summarise!
    data = Collators::GrossIncomeCollator.call(assessment)
    update!(data)
  end

  def housing_benefit_payments
    state_benefits.find_by(state_benefit_type_id: StateBenefitType.housing_benefit&.id)&.state_benefit_payments || []
  end

  def assessment_result
    Utilities::ResultSummarizer.call(eligibilities.map(&:assessment_result))
  end

  def eligible?
    assessment_result == :eligible
  end
end
