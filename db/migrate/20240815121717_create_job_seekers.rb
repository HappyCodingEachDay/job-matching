class CreateJobSeekers < ActiveRecord::Migration[7.1]
  def change
    create_table :job_seekers do |t|
      t.string :name, null: false
      t.json :skills

      t.timestamps
    end
  end
end
