class Tag < ApplicationRecord
  has_and_belongs_to_many :links

  def to_s
    # called by combobox for some godawful reason
    to_combobox_display
  end

  def to_combobox_display
    name
  end
end
