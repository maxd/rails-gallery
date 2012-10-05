class MediaItemsController < ApplicationController

  before_filter :init_scope

  def index
    age_filter = params[:age_filter] || :today
    age_condition = {
      all: nil,
      today: {:created_at.gt => 1.day.ago},
      last_3_days: {:created_at.gt => 3.days.ago},
      last_week: {:created_at.gt => 1.week.ago},
      last_month: {:created_at.gt => 1.month.ago},
      last_3_month: {:created_at.gt => 3.month.ago}
    }[age_filter.to_sym]

    type_filter = params[:type_filter] || :all
    type_condition = {
      all: nil,
      photos: {:file_type => :image},
      videos: {:file_type => :video}
    }[type_filter.to_sym]

    @media_items = @media_items_scope.where(age_condition).where(type_condition).all

    render layout: false
  end

private

  def init_scope
    if params[:album_id].present?
      @media_items_scope = Album.find(params[:album_id]).media_items
    else
      @media_items_scope = MediaItem
    end
  end

end
