class AddUserFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string
    add_column :users, :age, :integer
    add_column :users, :country, :string
    add_column :users, :annual_income, :integer
    add_column :users, :occupation, :string
  end
end
