FactoryBot.define do
  factory :assessment do
    sequence(:client_reference_id) { |n| format('CLIENT-REF-%<number>04d', number: n) }
    remote_ip { Faker::Internet.ip_v4_address }
    submission_date { Date.current }
    matter_proceeding_type { 'domestic_abuse' }
    proceeding_type_codes { ['DA001'] }
    version { '3' }

    trait :with_applicant do
      applicant { create :applicant, :under_pensionable_age }
    end

    trait :with_passported_applicant do
      applicant { create :applicant, :with_qualifying_benefits }
    end

    trait :with_non_passported_applicant do
      applicant { create :applicant, :without_qualifying_benefits }
    end

    trait :with_applicant_over_pensionable_age do
      applicant { create :applicant, :over_pensionable_age }
    end

    # use :with_child_dependants: 2 to create 2 children for the assessment
    transient do
      with_child_dependants { 0 }
    end

    trait :with_disposable_income_summary do
      after(:create) do |assessment|
        create :disposable_income_summary, assessment: assessment
      end
    end

    trait :with_capital_summary do
      after(:create) do |assessment|
        create :capital_summary, assessment: assessment
      end
    end

    trait :with_gross_income_summary do
      after(:create) do |assessment|
        create :gross_income_summary, assessment: assessment
      end
    end

    trait :with_gross_income_summary_and_records do
      after(:create) do |assessment|
        create :gross_income_summary, :with_all_records, assessment: assessment
      end
    end

    # NOTE: this ends up creating two assessments because the :with_non_passported_applicant trait
    # creates one too
    #
    trait :with_everything do
      with_non_passported_applicant
      after(:create) do |assessment|
        create :gross_income_summary, :with_everything, assessment: assessment
        create :disposable_income_summary, :with_everything, assessment: assessment
        create :capital_summary, :with_everything, assessment: assessment
      end
    end

    trait :passported do
      with_passported_applicant
      after(:create) do |assessment|
        create :capital_summary, :with_everything, assessment: assessment
      end
    end

    trait :with_eligibilities do
      after(:create) do |assessment|
        if assessment.capital_summary
          assessment.proceeding_type_codes.each do |ptc|
            assessment.capital_summary.eligibilities << create(:capital_eligibility, proceeding_type_code: ptc)
          end
        end

        if assessment.gross_income_summary
          assessment.proceeding_type_codes.each do |ptc|
            assessment.gross_income_summary.eligibilities << create(:gross_income_eligibility, proceeding_type_code: ptc)
          end
        end

        if assessment.disposable_income_summary
          assessment.proceeding_type_codes.each do |ptc|
            assessment.disposable_income_summary.eligibilities << create(:disposable_income_eligibility, proceeding_type_code: ptc)
          end
        end
      end
    end

    after(:create) do |assessment, evaluator|
      if evaluator.with_child_dependants > 0
        evaluator.with_child_dependants.times do
          create :dependant, :child_relative, assessment: assessment
        end
      end
    end
  end
end
