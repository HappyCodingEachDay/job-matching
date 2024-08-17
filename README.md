# README

## Data Structure
When designing a job recommendation system based on skills, we can use different methods to store and query the data: plain text, NoSql(ES, MongoDb), relational tables, or MySQL’s JSON data type with built-in functions.
After comparing these methods, I believe the best choice for this case is **MySQL’s JSON data type with its built-in functions**.

**Reasons**:
- **Structured Data**: JSON lets us store data in a structured way with arrays and nested objects, making it easy to manage and query without changing the database schema.
- **Powerful Functions**: MySQL offers JSON functions like `JSON_CONTAINS`, `JSON_LENGTH`, and `JSON_TABLE`, which make it simple to check for matching skills and compute results.
- **Simpler Schema**: By using JSON fields, we can keep the schema simple, reducing the number of tables and joins.
- **Efficient Queries**: MySQL’s JSON functions are designed to be fast and efficient, improving query performance.

## Performance Considerations
To handle large-scale data effectively, it's crucial to manage how much data is processed in each query. The `RecommendationService` uses `batch_size` and `offset` parameters are to control and optimize query.

## Project Structure
```
tree              
.
├── Dockerfile
├── Gemfile
├── Gemfile.lock
├── README.md
├── Rakefile
├── app
│   └── models
│       ├── job.rb
│       └── job_seeker.rb
│       └── recommendation.rb
├── config
│   ├── database.yml
├── config.ru
├── db
│   ├── migrate
│   │   ├── 20240815121650_create_jobs.rb
│   │   └── 20240815121717_create_job_seekers.rb
│   │   └── 20240817115501_create_recommendations.rb
│   ├── schema.rb
├── docker-compose.yml
├── example_data
│   ├── jobs.csv
│   └── jobseekers.csv
├── lib
│   ├── csv_importer.rb
│   ├── recommendation_service.rb
│   └── tasks
│       ├── data.rake
│       └── recommendation.rake
├── my.cnf
├── spec
│   ├── fixtures
│   │   ├── job_seekers.csv
│   │   └── jobs.csv
│   ├── lib
│   │   ├── csv_importer_spec.rb
│   │   └── recommendation_service_spec.rb
│   ├── rails_helper.rb
│   ├── spec_helper.rb
```

## Local Setup
#### Version
- Ruby 3.0.0
- Rails 7.1.3.4

#### Configure Environment File

1. **Rename and Configure Environment File**
   Rename `.env.example` to `.env`, update the `.env` file with your database configuration settings.

2. **Run Database Migrations**

   Apply the database migrations:
   ```bash
   rake db:migrate
   ```

#### Import Data from CSV

1. **Import Jobs Data**

   To import jobs data from CSV:
   ```bash 
   bin/rake data:import_job_from_csv\['example_data/jobs.csv'\]
   ```

2. **Import Job Seekers Data**

   To import job seekers data from CSV:
   ```bash
   rake data:import_job_seeks_from_csv['example_data/jobseekers.csv'] 
   ```

#### Generate Recommendations

To generate recommendations:
```bash
bin/rake data:recommendations
```

#### Running Tests

1. **Set Up Test Database**
   ```bash
   bundle exec rails db:setup RAILS_ENV=test 
   ```

2. **Test CSV Import Functionality**
   ```bash
   bundle exec rspec spec/lib/csv_importer_spec.rb
   ```

3. **Test Recommendation Functionality**
   ```bash
   bundle exec rspec spec/lib/recommendation_service_spec.rb
   ```

## Docker Compose Setup

#### Set Up and Run Docker Compose

1. **Build and Start Docker Containers**

   Build the Docker images and start the containers. This will also create the database and run migrations:
   ```bash
   docker compose up -d
   ```

   This command will build the Docker images and start the containers defined in `docker-compose.yml`. It also ensures that the database is created and migrations are applied.

#### Import Data from CSV

1. **Import Jobs Data**

   Import jobs data from CSV into a Docker container:
   ```bash
   docker-compose run --rm -v /path-to-your-job-csv-file:/rails/example_data/jobs.csv app bundle exec rake "data:import_job_from_csv[/rails/example_data/jobs.csv]"
   ```

2. **Import Job Seekers Data**

   Import job seekers data from CSV into a Docker container:
   ```bash
   docker-compose run --rm -v /path-to-your-job-csv-file:/rails/example_data/jobseekers.csv app bundle exec rake "data:import_job_seeks_from_csv[/rails/example_data/jobseekers.csv]"
   ```

#### Generate Recommendations

To generate recommendations in a Docker container:
```bash
docker-compose run app bundle exec rake "data:recommendations"
```

- Example Output
```
jobseeker_id,jobseeker_name,job_id,job_title,matching_skill_count,matching_skill_percent
1,Alice Seeker,1,Ruby Developer,3,100
1,Alice Seeker,3,Backend Developer,2,50
1,Alice Seeker,9,Python Developer,2,50
1,Alice Seeker,4,Fullstack Developer,2,33
1,Alice Seeker,7,Data Analyst,1,25
1,Alice Seeker,8,Web Developer,1,25
2,Bob Applicant,2,Frontend Developer,3,75
2,Bob Applicant,8,Web Developer,3,75
2,Bob Applicant,4,Fullstack Developer,2,33
2,Bob Applicant,10,JavaScript Developer,1,25
3,Charlie Jobhunter,3,Backend Developer,3,75
3,Charlie Jobhunter,1,Ruby Developer,2,67
3,Charlie Jobhunter,9,Python Developer,2,50
3,Charlie Jobhunter,7,Data Analyst,1,25
3,Charlie Jobhunter,4,Fullstack Developer,1,17
4,Danielle Searcher,5,Machine Learning Engineer,3,100
4,Danielle Searcher,7,Data Analyst,3,75
4,Danielle Searcher,6,Cloud Architect,1,33
4,Danielle Searcher,9,Python Developer,1,25
5,Eddie Aspirant,6,Cloud Architect,2,67
5,Eddie Aspirant,4,Fullstack Developer,1,17
6,Fiona Candidate,7,Data Analyst,3,75
6,Fiona Candidate,5,Machine Learning Engineer,2,67
6,Fiona Candidate,9,Python Developer,2,50
6,Fiona Candidate,1,Ruby Developer,1,33
6,Fiona Candidate,6,Cloud Architect,1,33
6,Fiona Candidate,3,Backend Developer,1,25
6,Fiona Candidate,4,Fullstack Developer,1,17
7,George Prospect,8,Web Developer,4,100
7,George Prospect,2,Frontend Developer,3,75
7,George Prospect,4,Fullstack Developer,3,50
7,George Prospect,1,Ruby Developer,1,33
7,George Prospect,10,JavaScript Developer,1,25
8,Hannah Hunter,9,Python Developer,2,50
8,Hannah Hunter,1,Ruby Developer,1,33
8,Hannah Hunter,5,Machine Learning Engineer,1,33
8,Hannah Hunter,6,Cloud Architect,1,33
8,Hannah Hunter,3,Backend Developer,1,25
8,Hannah Hunter,7,Data Analyst,1,25
9,Ian Jobhunter,10,JavaScript Developer,3,75
9,Ian Jobhunter,2,Frontend Developer,2,50
9,Ian Jobhunter,8,Web Developer,1,25
9,Ian Jobhunter,9,Python Developer,1,25
9,Ian Jobhunter,4,Fullstack Developer,1,17
10,Jane Applicant,1,Ruby Developer,1,33
10,Jane Applicant,8,Web Developer,1,25
10,Jane Applicant,9,Python Developer,1,25
10,Jane Applicant,10,JavaScript Developer,1,25
10,Jane Applicant,4,Fullstack Developer,1,17
```
