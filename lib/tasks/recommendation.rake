require 'csv'

namespace :data  do
  task recommendations: :environment do 
    batch_size = 1
    job_seeker_count = JobSeeker.count
    dataset = []

    (0...job_seeker_count).step(batch_size) do |offset|
      dataset += RecommendationService.caculate_recommendations!(batch_size, offset)
    end

    # save to database
    save_to_db(dataset)
    # print to console
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

def save_to_db(dataset)
  current_time = Time.current
  records = dataset.map{|r| {job_seeker_id: r[0], job_id: r[2], matching_skill_count: r[4], matching_skill_percent: r[5], updated_at: current_time}}
  Recommendation.upsert_all(records)
end

# Usage: rake data:recommendations