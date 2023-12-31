# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.insert_all(
  100.times.map do |n|
    { screen_name: [Faker::Lorem.word, n.to_s.rjust(3, '0')].join("_"),
      created_at: Faker::Time.between(from: 1.week.ago, to: DateTime.now) }
  end
)
user_ids_and_created_ats = User.pluck(:id, :created_at)
1_000.times do |n|
  user_id, created_at = user_ids_and_created_ats.sample
  results = Post.insert({
    user_id: user_id,
    title: Faker::Lorem.sentence[0..-2],
    description: Faker::Lorem.paragraphs.join("\n"),
    created_at: Faker::Time.between(from: created_at, to: DateTime.now)
  }, returning: [:id, :created_at])
  result = results.to_a[0]
  rand(5..15).times do |nn|
    Comment.insert({
      post_id: result["id"],
      user_id: user_ids_and_created_ats.sample.first,
      body: Faker::Lorem.paragraphs.join("\n"),
      created_at: Faker::Time.between(from: result["created_at"], to: DateTime.now)
    })
  end
end

Post.pluck(:id).each { |post_id| Post.reset_counters(post_id, :comments) }
User.pluck(:id).each { |user_id| User.reset_counters(user_id, :posts) }
