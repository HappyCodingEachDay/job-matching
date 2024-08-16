require 'rails_helper'
require 'csv'

RSpec.describe RecommendationService, type: :service do
  describe '.caculate_recommendations!' do
    let(:batch_size) { 10 }
    let(:offset) { 0 }

    before do
      # Load test data from CSV files
      load_job_seekers_from_csv('spec/fixtures/job_seekers.csv')
      load_jobs_from_csv('spec/fixtures/jobs.csv')
    end
    
    it 'returns the correct recommendations' do
      results = RecommendationService.caculate_recommendations!(batch_size, offset)
      
      expect(results).to be_an(Array)
      expect(results.size).to eq(40)
      
      result = results.first
      expect(result[0]).to eq(JobSeeker.first.id)
      expect(result[1]).to eq(JobSeeker.first.name)
      expect(result[2]).to eq(1)
      expect(result[3]).to eq("Ruby Developer")
      expect(result[4]).to eq(3) # matching_skill_count
      expect(result[5]).to eq(100) # matching_skill_percent
    end
  end

  private

  def load_job_seekers_from_csv(filepath)
    CSV.foreach(filepath, headers: true) do |row|
      JobSeeker.create!(
        id: row['id'],
        name: row['name'],
        skills: row['skills'].split(",")
      )
    end
  end

  def load_jobs_from_csv(filepath)
    CSV.foreach(filepath, headers: true) do |row|
      Job.create!(
        id: row['id'],
        title: row['title'],
        required_skills: row['required_skills'].split(',')
      )
    end
  end
end
