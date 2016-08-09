class CreateYahooDates < ActiveRecord::Migration

    def change
        create_table :yahoo_dates do |t|
            t.date      :date
            t.float     :open
            t.float     :high
            t.float     :low
            t.float     :close
            t.integer   :vol,limit:8
            t.float     :adj_close

            t.belongs_to :company

        end
    end
end
