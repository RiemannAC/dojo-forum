class Comment < ApplicationRecord
  validates_presence_of :content

  belongs_to :user, counter_cache: true
  belongs_to :post, counter_cache: true
end
