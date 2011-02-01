class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string :name
      t.integer :template_type_id
      t.integer :template_set_id
      t.integer :theme_id
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :templates
  end
end
