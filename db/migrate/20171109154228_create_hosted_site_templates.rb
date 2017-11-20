class CreateHostedSiteTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :hosted_site_templates do |t|

      t.timestamps
    end
  end
end
