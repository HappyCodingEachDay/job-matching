# == Schema Information
#
# Table name: jobs
#
#  id              :bigint           not null, primary key
#  required_skills :json
#  title           :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Job < ApplicationRecord
end
