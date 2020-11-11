module RemarkGenerators
  class FrequencyChecker
    def self.call(assessment, collection)
      new(assessment, collection).call
    end

    def initialize(assessment, collection)
      @assessment = assessment
      @collection = collection
    end

    def call
      populate_remarks if unknown_frequency? && !exempt_from_checking
    end

    private

    def unknown_frequency?
      Utilities::PaymentPeriodAnalyser.new(dates_and_amounts).period_pattern == :unknown
    end

    def dates_and_amounts
      @collection.map { |rec| [rec.payment_date, nil] }
    end

    def populate_remarks
      my_remarks = @assessment.remarks
      my_remarks.add(record_type, :unknown_frequency, @collection.map(&:client_id))
      @assessment.update!(remarks: my_remarks)
    end

    def record_type
      @collection.first.class.to_s.underscore.tr('/', '_').to_sym
    end

    def exempt_from_checking
      childcare_payment? && childcare_disallowed?
    end

    def childcare_payment?
      record_type == :outgoings_childcare
    end

    def childcare_disallowed?
      @assessment.disposable_income_summary.childcare.zero?
    end
  end
end
