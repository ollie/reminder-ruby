ActiveRecord::Schema.define do 
  create_table :events do |t|
    t.boolean :show, :default => true
    t.boolean :birthday
    t.boolean :nameday
    t.boolean :payment
    t.boolean :paid
    t.integer :year
    t.integer :month
    t.integer :day
    t.string :name
  end
end