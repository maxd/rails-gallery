class Album
  include Mongoid::Document

  field :title, type: String
  field :description, type: String
  field :is_public, type: Boolean, default: false

  attr_accessible :title, :description, :is_public

  validates_presence_of :title
end
