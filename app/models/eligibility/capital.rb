module Eligibility
  class Capital < Base
    belongs_to :capital_summary, foreign_key: :parent_id
  end
end
