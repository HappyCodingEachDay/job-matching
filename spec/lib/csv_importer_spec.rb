require 'rails_helper'
require 'csv'
require 'tempfile'

RSpec.describe CsvImporter, type: :module do
  let(:job_csv_content) do
    "id,title,required_skills\n1,Software Engineer,\"Ruby,JavaScript\"\n2,Data Scientist,\"Python,SQL\""
  end

  let(:job_seeker_csv_content) do
    "id,name,skills\n1,Alice,\"Ruby,Python\"\n2,Bob,\"JavaScript,SQL\""
  end

  # Create temporary files before each test
  let(:job_csv_file) do
    Tempfile.new(['jobs', '.csv']).tap do |file|
      file.write(job_csv_content)
      file.rewind
    end
  end

  let(:job_seeker_csv_file) do
    Tempfile.new(['job_seekers', '.csv']).tap do |file|
      file.write(job_seeker_csv_content)
      file.rewind
    end
  end

  after do
    job_csv_file.unlink
    job_seeker_csv_file.unlink
  end

  describe '.import_jobs_from_csv' do
    it 'imports jobs successfully from a CSV file' do
      expect(Job).to receive(:upsert_all).with([
        { id: 1, title: 'Software Engineer', required_skills: ['Ruby', 'JavaScript'] },
        { id: 2, title: 'Data Scientist', required_skills: ['Python', 'SQL'] }
      ])

      CsvImporter.import_jobs_from_csv(job_csv_file.path)
    end

    it 'raises an error if required fields are missing' do
      invalid_csv_content = "id,title,required_skills\n1,Software Engineer,\n2,,Python,SQL"
      invalid_csv_file = Tempfile.new(['invalid_jobs', '.csv'])
      invalid_csv_file.write(invalid_csv_content)
      invalid_csv_file.rewind

      expect {
        CsvImporter.import_jobs_from_csv(invalid_csv_file.path)
      }.to raise_error(/Validation failed in file/)

      invalid_csv_file.unlink
    end
  end

  describe '.import_job_seekers_from_csv' do
    it 'imports job seekers successfully from a CSV file' do
      expect(JobSeeker).to receive(:upsert_all).with([
        { id: 1, name: 'Alice', skills: ['Ruby', 'Python'] },
        { id: 2, name: 'Bob', skills: ['JavaScript', 'SQL'] }
      ])

      CsvImporter.import_job_seekers_from_csv(job_seeker_csv_file.path)
    end

    it 'raises an error if required fields are missing' do
      invalid_csv_content = "id,name,skills\n1,Alice,\n2,,JavaScript,SQL"
      invalid_csv_file = Tempfile.new(['invalid_job_seekers', '.csv'])
      invalid_csv_file.write(invalid_csv_content)
      invalid_csv_file.rewind

      expect {
        CsvImporter.import_job_seekers_from_csv(invalid_csv_file.path)
      }.to raise_error(/Validation failed in file/)

      invalid_csv_file.unlink
    end
  end
end
