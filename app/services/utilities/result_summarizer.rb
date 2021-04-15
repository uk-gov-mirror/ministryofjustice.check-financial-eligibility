module Utilities
  class ResultSummarizer
    def self.call(individual_results)
      uniq_results = individual_results.uniq

      return :eligible if uniq_results == [:eligible]

      return :ineligible if uniq_results == [:ineligible]

      return :eligible_with_contribution if uniq_results == [:eligible_with_contribution]

      return :eligible_with_contribution unless uniq_results.include?(:ineligible)

      :partially_eligible
    end
  end
end
