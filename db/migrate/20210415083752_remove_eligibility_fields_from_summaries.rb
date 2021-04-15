class RemoveEligibilityFieldsFromSummaries < ActiveRecord::Migration[6.1]
  def change
    remove_column :gross_income_summaries, :assessment_result, :string
    remove_column :gross_income_summaries, :upper_threshold, :decimal, default: 0.0, null: false

    remove_column :disposable_income_summaries, :assessment_result, :string
    remove_column :disposable_income_summaries, :upper_threshold, :decimal, default: 0.0, null: false
    remove_column :disposable_income_summaries, :lower_threshold, :decimal, default: 0.0, null: false

    remove_column :capital_summaries, :assessment_result, :string
    remove_column :capital_summaries, :upper_threshold, :decimal, default: 0.0, null: false
    remove_column :capital_summaries, :lower_threshold, :decimal, default: 0.0, null: false
  end

end
