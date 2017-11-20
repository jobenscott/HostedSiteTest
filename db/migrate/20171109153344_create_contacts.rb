class CreateContacts < ActiveRecord::Migration[5.1]
 	def change
	    create_table :contacts do |t|
	      t.references :user, foreign_key: true
	      t.datetime :user_create
	      t.datetime :last_user_update
	      t.string :name
	      t.string :location_address
	      t.string :location_city
	      t.string :location_zipcode
	      t.string :mobile_phone_number
	      t.string :other_phone
	      t.string :email_address
	      t.text :general_notes

	      t.timestamps
	    end
 	end
end
