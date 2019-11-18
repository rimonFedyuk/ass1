class AddUserPassword < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :password_digest, :string, :null => false, :default => ""
    add_column :users, :current_session_token, :string, :null => false, :default => ""
  end
end
