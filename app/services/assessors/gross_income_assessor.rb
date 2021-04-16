module Assessors
  class GrossIncomeAssessor < BaseWorkflowService
    def call
      raise 'Gross income not summarised' if gross_income_summary.summarized_assessment_result == 'pending'

      gross_income_summary.eligibilities.each do |elig|
        elig.update!(assessment_result: assessment_result(elig))
      end
    end

    private

    def assessment_result(elig)
      income < elig.upper_threshold ? 'eligible' : 'ineligible'
    end

    def income
      gross_income_summary.total_gross_income
    end
  end
end
