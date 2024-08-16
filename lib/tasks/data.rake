namespace :data do
  desc "Import job from CSV file"
  task :import_job_from_csv, [:file] => :environment do |_, args|
    CsvImporter.import_jobs_from_csv(args[:file])
  end

  desc "Import job_seekers from CSV file"
  task :import_job_seeks_from_csv, [:file] => :environment do |_, args|
    CsvImporter.import_job_seekers_from_csv(args[:file])
  end
end

# Usage:
# rake data:import_job_from_csv\['example_data/jobs.csv'\] 
# rake data:import_job_seeks_from_csv\['example_data/jobseekers.csv'\] 