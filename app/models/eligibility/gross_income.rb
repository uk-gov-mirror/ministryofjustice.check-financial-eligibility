module Eligibility
  class GrossIncome < Base
    belongs_to :gross_income_summary, inverse_of: :eligibilities, foreign_key: :parent_id
  end
end
