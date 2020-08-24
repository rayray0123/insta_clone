puts 'Start inserting seed "users" ...'
3.times do
  user = User.create(
    # Fakerの一覧 https://github.com/faker-ruby/faker/blob/master/README.md
    # uniqueで重複防止
    # 先輩達がFakerを楽しそうに使っておられたので自分も少しやってみた
      email: Faker::Internet.unique.email,
      username: Faker::Music::RockBand.unique.name,
      password: 'password',
      password_confirmation: 'password'
      )
  puts "\"#{user.username}\" has created!"
end
