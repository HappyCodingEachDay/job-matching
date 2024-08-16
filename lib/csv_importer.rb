require 'csv'

module CsvImporter
  def self.import_jobs_from_csv(file)
    raise "No Job file specified" unless file.present?

    job_attributes = []
    CSV.foreach(file, headers: true, converters: [lambda { |field| field.nil? || field.empty? ? nil : field }], quote_char: '"', col_sep: ',') do |row|
      r = row.to_h
      if r['id'].blank? || r['title'].blank? || r['required_skills'].blank?
        raise "Validation failed in file #{file}, #{r}"
      end

      required_skills = r['required_skills'].split(',').map(&:strip)
      raise "required_skills empty" if required_skills.blank?

      job_attributes << { id: r['id'].to_i, title: r['title'].strip, required_skills: required_skills }
    end
    Job.upsert_all(job_attributes)
    puts "Job Data imported successfully from #{file}"
  end

  def self.import_job_seekers_from_csv(file)
    raise "No Job seeker file specified" unless file.present?

    seekers_attributes = []
    CSV.foreach(file, headers: true, converters: [lambda { |field| field.nil? || field.empty? ? nil : field }], quote_char: '"', col_sep: ',') do |row|
      r = row.to_h
      if r['id'].blank? || r['name'].blank? || r['skills'].blank?
        raise "Validation failed in file #{file}, #{r}"
      end

      skills = r['skills'].split(',').map(&:strip)
      raise "skills empty" if skills.blank?

      seekers_attributes << { id: r['id'].to_i, name: r['name'].strip, skills: skills }
    end
    JobSeeker.upsert_all(seekers_attributes)
    puts "Job seekers imported successfully from #{file}"
  end
end
