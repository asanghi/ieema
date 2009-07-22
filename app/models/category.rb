class Category < ActiveRecord::Base

  has_many :formulas, :dependent => :destroy
  validates_presence_of :name
  
end
