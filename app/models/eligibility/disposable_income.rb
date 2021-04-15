module Eligibility
  class DisposableIncome < Base
    belongs_to :disposable_income_summary, foreign_key: :parent_id
  end
end
