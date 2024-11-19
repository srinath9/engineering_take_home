class CreateClientCustomFields < ActiveRecord::Migration[7.2]
  def change
    create_table :client_custom_fields do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name
      t.integer :field_type
      t.json :enum_options

      t.timestamps
    end
  end
end
