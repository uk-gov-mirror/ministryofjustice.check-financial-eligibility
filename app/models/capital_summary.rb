class CapitalSummary < ApplicationRecord
  extend EnumHash

  belongs_to :assessment

  has_many :capital_items, dependent: :destroy
  has_many :liquid_capital_items, dependent: :destroy
  has_many :non_liquid_capital_items, dependent: :destroy
  has_many :vehicles, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :additional_properties, -> { additional }, inverse_of: :capital_summary, class_name: 'Property', dependent: :destroy
  has_one :main_home, -> { main_home }, inverse_of: :capital_summary, class_name: 'Property', dependent: :destroy
  has_many :eligibilities,
           class_name: 'Eligibility::Capital',
           foreign_key: :parent_id,
           inverse_of: :capital_summary,
           dependent: :destroy

  def summarized_assessment_result
    Utilities::ResultSummarizer.call(eligibilities.map(&:assessment_result))
  end
end
