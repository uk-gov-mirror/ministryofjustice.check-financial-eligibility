module ThresholdManagers
  class Capital
    def self.call(capital_summary)
      new(capital_summary).call
    end

    def initialize(capital_summary)
      @summary = capital_summary
      @assessment = @summary.assessment
    end

    def call
      @assessment.proceeding_type_codes.each { |code| find_or_create_eligibility_record(code) }
    end

    private

    def find_or_create_eligibility_record(code)
      @summary.eligibilities.create!(proceeding_type_code: code,
                                     upper_threshold: upper_threshold(code),
                                     lower_threshold: lower_threshold(code),
                                     assessment_result: 'pending')
    end

    def upper_threshold(code)
      ProceedingTypeThreshold.value_for(code.to_sym, :capital_upper, @assessment.submission_date)
    end

    def lower_threshold(code)
      ProceedingTypeThreshold.value_for(code.to_sym, :capital_lower, @assessment.submission_date)
    end
  end
end
