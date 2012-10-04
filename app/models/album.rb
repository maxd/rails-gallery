class Album
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :description, type: String
  field :is_public, type: Boolean, default: false

  validates_presence_of :title

  has_and_belongs_to_many :media_items

  attr_accessible :title
  attr_accessible :description
  attr_accessible :is_public
end
