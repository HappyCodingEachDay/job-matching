require 'csv'

namespace :data  do
  task recommendations: :environment do 
    batch_size = 1
    job_seeker_count = JobSeeker.count
    dataset = []

    (0...job_seeker_count).step(batch_size) do |offset|
      dataset += RecommendationService.caculate_recommendations!(batch_size, offset)
    end

    print_result(dataset)
  end
end

private
def print_result(dataset)
    headers = ['jobseeker_id', 'jobseeker_name', 'job_id', 'job_title', 'matching_skill_count', 'matching_skill_percent']
    csv_content = headers.join(',') + "\n"
    dataset.each do |r|
      csv_content += r.join(',') + "\n"
    end

    puts csv_content
end

# Usage: rake data:recommendations