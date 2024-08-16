module RecommendationService
  def self.caculate_recommendations!(batch_size, offset)
    sql = <<-SQL
        SELECT
            js.id AS jobseeker_id,
            js.name AS jobseeker_name,
            j.id AS job_id,
            j.title AS job_title,
            JSON_LENGTH(js.skills) AS total_skills_count,
            JSON_LENGTH(j.required_skills) AS required_skills_count,
            SUM(JSON_CONTAINS(j.required_skills, JSON_QUOTE(skill), '$')) AS matching_skill_count,
            ROUND(
                (SUM(JSON_CONTAINS(j.required_skills, JSON_QUOTE(skill), '$')) / JSON_LENGTH(j.required_skills)) * 100,
                0
            ) AS matching_skill_percent
        FROM
            (SELECT * FROM job_seekers ORDER BY id LIMIT #{batch_size} OFFSET #{offset}) js
        CROSS JOIN
            jobs j
        JOIN
            JSON_TABLE(
                js.skills,
                '$[*]' COLUMNS (
                    skill VARCHAR(255) PATH '$'
                )
            ) js_skills ON JSON_CONTAINS(j.required_skills, JSON_QUOTE(js_skills.skill), '$')
        GROUP BY
            js.id, js.name, j.id, j.title
        ORDER BY
            js.id, matching_skill_percent DESC, j.id;
      SQL

      recommendations = ActiveRecord::Base.connection.execute(sql)
      recommendations.map { |r| [r[0], r[1], r[2], r[3], r[6], r[7]] }
  end
end
