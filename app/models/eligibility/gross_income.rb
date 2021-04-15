module Eligibility
  class GrossIncome < Base
    belongs_to :gross_income_summary, foreign_key: :parent_id
  end
end
