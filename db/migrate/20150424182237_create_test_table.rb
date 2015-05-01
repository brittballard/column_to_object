class CreateTestTable < ActiveRecord::Migration
  def change
    create_table :test_tables do |t|
      t.timestamps

      t.json :my_object
    end
  end
end
