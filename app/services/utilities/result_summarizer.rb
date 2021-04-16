module Utilities
  class ResultSummarizer
    def self.call(individual_results)
      return :pending if individual_results.empty?

      uniq_results = individual_results.uniq.map(&:to_sym)
      return :pending if uniq_results.include?(:pending)

      return :eligible if uniq_results == [:eligible]

      return :ineligible if uniq_results == [:ineligible]

      return :contribution_required if uniq_results == [:contribution_required]

      return :contribution_required unless uniq_results.include?(:ineligible)

      :partially_eligible
    end
  end
end
