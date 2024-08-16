# == Schema Information
#
# Table name: job_seekers
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  skills     :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class JobSeeker < ApplicationRecord
end
