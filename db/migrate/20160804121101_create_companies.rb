class CreateCompanies < ActiveRecord::Migration

    def change
        create_table :companies do |t|
            t.string :am_stock_serial_num
            t.string :short_name
            t.string :full_name
            t.string :english_name
            t.text   :location
            t.string :am_stock_name
            t.date   :public_date
            t.integer :all_shares,limit:8
            t.integer :tradable_shares,limit:8
            t.string :area
            t.string :province
            t.string :city
            t.string :industry
            t.string :url
            t.timestamps
        end

    end
end
