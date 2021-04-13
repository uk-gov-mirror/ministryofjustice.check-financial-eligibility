module MigrationHelpers
  class ProceedingTypeCodeSeeder
    def self.call
      new.call
    end

    def call
      assessments = Assessment.where(version: '3', proceeding_type_codes: nil)
      assessments.each do |rec|
        rec.update!(proceeding_type_codes: ['DA001'])
      end
    end
  end
end
