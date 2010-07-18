class Image < ActiveRecord::Base

  attr_accessible :type, :image_filename, :image_width, :image_height, :caption,
    :position, :visible, :imageable_id, :imageable_type, :image_file

  belongs_to :imageable, :polymorphic => true, :validate => true
end
