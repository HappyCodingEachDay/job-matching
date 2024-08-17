# == Schema Information
#
# Table name: recommendations
#
#  id                     :bigint           not null, primary key
#  matching_skill_count   :integer          default(0)
#  matching_skill_percent :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  job_id                 :bigint           not null
#  job_seeker_id          :bigint           not null
#
# Indexes
#
#  index_recommendations_on_job_id                    (job_id)
#  index_recommendations_on_job_id_and_job_seeker_id  (job_id,job_seeker_id) UNIQUE
#  index_recommendations_on_job_seeker_id             (job_seeker_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (job_seeker_id => job_seekers.id)
#
class Recommendation < ApplicationRecord
end
