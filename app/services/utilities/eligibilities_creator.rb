module Utilities
  # EligibilitiesCreator is responsible for setting up all the eligibility
  # records for each proceeding type code for an assessment
  #
  class EligibilitiesCreator
    SUMMARY_ASSOCIATIONS = %i[capital_summary gross_income_summary disposable_income_summary].freeze

    def self.call(assessment)
      new(assessment).call
    end

    def initialize(assessment)
      @assessment = assessment
    end

    def call
      SUMMARY_ASSOCIATIONS.each { |assoc| create_eligibilities_for_assoc(assoc) }
    end

    private

    def create_eligibilities_for_assoc(assoc)
      @assessment.proceeding_type_codes.each { |ptc| create_eligibility(assoc, ptc) }
    end

    def create_eligibility(assoc, ptc)
      attrs = generate_attrs(assoc, ptc)
      summary = @assessment.__send__(assoc)
      summary.eligibilities.create!(attrs)
    end

    def generate_attrs(assoc, ptc)
      case assoc
      when :capital_summary
        generate_capital_attrs(ptc)
      when :disposable_income_summary
        generate_disposable_attrs(ptc)
      when :gross_income_summary
        generate_gross_attrs(ptc)
      else
        raise "Unexpected association #{assoc.inspect}"
      end
    end

    def generate_capital_attrs(ptc)
      {
        proceeding_type_code: ptc,
        upper_threshold: ProceedingTypeThreshold.value_for(ptc.to_sym, :capital_upper, @assessment.submission_date),
        lower_threshold: ProceedingTypeThreshold.value_for(ptc.to_sym, :capital_lower, @assessment.submission_date),
        assessment_result: 'pending'
      }
    end

    def generate_disposable_attrs(ptc)
      {
        proceeding_type_code: ptc,
        upper_threshold: ProceedingTypeThreshold.value_for(ptc.to_sym, :disposable_income_upper, @assessment.submission_date),
        lower_threshold: ProceedingTypeThreshold.value_for(ptc.to_sym, :disposable_income_lower, @assessment.submission_date),
        assessment_result: 'pending'
      }
    end

    def generate_gross_attrs(ptc)
      {
        proceeding_type_code: ptc,
        upper_threshold: ProceedingTypeThreshold.value_for(ptc.to_sym, :gross_income_upper, @assessment.submission_date),
        assessment_result: 'pending'
      }
    end
  end
end
