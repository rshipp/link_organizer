class TagChipsController < ApplicationController
  def create_possibly_new
    @tags = params[:combobox_values].split(",").map do |value|
      Tag.find_by(id: value) || OpenStruct.new(to_combobox_display: value, id: value)
    end

    render turbo_stream: helpers.combobox_selection_chips_for(@tags)
  end
end
