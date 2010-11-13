class CreateTemplateTypes < ActiveRecord::Migration
  def self.up
    create_table :template_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :template_types
  end
end
