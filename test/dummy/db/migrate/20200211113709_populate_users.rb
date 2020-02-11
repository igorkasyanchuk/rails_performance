class PopulateUsers < ActiveRecord::Migration[6.0]
  def change
    puts "populating 50K users ..."
    50_000.times do
      User.create(first_name: "John #{rand(10000)}", age: rand(100))
    end
  end
end
