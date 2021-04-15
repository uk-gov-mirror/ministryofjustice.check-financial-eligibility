module Utilities
  class ResultSummarizer
    def self.call(individual_results)
      return :pending if individual_results.empty?

      uniq_results = individual_results.uniq.map(&:to_sym)
      return :pending if uniq_results.include?(:pending)

      return :eligible if uniq_results == [:eligible]

      return :ineligible if uniq_results == [:ineligible]

      return :eligible_with_contribution if uniq_results == [:eligible_with_contribution]

      return :eligible_with_contribution unless uniq_results.include?(:ineligible)

      :partially_eligible
    end
  end
end
