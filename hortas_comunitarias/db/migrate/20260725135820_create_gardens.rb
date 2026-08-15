class CreateGardens < ActiveRecord::Migration[8.0]
  def change
    create_table :gardens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description, null: false
      t.integer :garden_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.string :street, null: false
      t.string :number
      t.string :district, null: false
      t.string :city, null: false, default: "Itu"
      t.string :state, null: false, default: "SP"
      t.string :postal_code
      t.st_point :coordinates, geographic: true, srid: 4326
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.boolean :accepts_volunteers, null: false, default: false

      t.timestamps
    end

    add_index :gardens, :coordinates, using: :gist
    add_index :gardens, :status
    add_index :gardens, [:city, :district]
  end
end
