# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[
  ['news_article','source_type'],
  ['academic_article','source_type'],
  ['social_post','source_type'],
  ['podcast','source_type'],
  ['video','source_type'],
  ['blog_post','source_type'],
  ['environment','topic'],
  ['labor','topic'],
  ['bigotry','topic'],
  ['eugenics','topic'],
  ['colonialism','topic'],
  ['centralization_of_power','topic'],
  ['racism','topic'],
  ['transphobia','topic'],
  ['sexism','topic'],
  ['ableism','topic'],
  ['incorrectness','topic'],
  ['privacy','topic'],
  ['healthcare','topic'],
  ['surveilance','topic'],
  ['anthropomorphizing','topic'],
  ['chatbots','topic'],
  ['llms','topic'],
  ['image_generation','topic'],
  ['background','topic'],
  ['ip_theft','topic'],
  ['cheating','topic'],
  ['education','topic'],
  ['prompt_injection','topic'],
  ['book','source_type'],
  ['palestine','topic'],
  ['therapy','topic'],
].each do |name, category|
  Tag.find_or_create_by!(name: name, category: category)
end
