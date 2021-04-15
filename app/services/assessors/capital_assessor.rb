module Assessors
  class CapitalAssessor < BaseWorkflowService
    delegate :assessed_capital, :lower_threshold, to: :capital_summary

    def call
      capital_summary.eligibilites.each { |elig| elig.update_assessment_result! }
      summary_result
    end

    private

    def summary_result
      Utilities::ResulsSummarizer.call(capital_summary.eligibilites.map(&:assessment_result))
    end


  end
end
