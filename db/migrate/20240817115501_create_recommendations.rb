class CreateRecommendations < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendations do |t|
      t.references :job, null: false, foreign_key: true
      t.references :job_seeker, null: false, foreign_key: true
      t.integer :matching_skill_count, default: 0
      t.integer :matching_skill_percent,  default: 0

      t.timestamps
    end
    
    add_index :recommendations, [:job_id, :job_seeker_id], unique: true
  end
end
