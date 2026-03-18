class AddParentSectionLabelToVenues < ActiveRecord::Migration[7.2]
  def change
    add_column :venues, :parent_section_label, :string
  end
end
