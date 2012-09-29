class Item
  include Mongoid::Document

  field :title, type: String

  attr_accessible :title

  validates_presence_of :title

  has_and_belongs_to_many :albums
end
