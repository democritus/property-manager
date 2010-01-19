class FeatureAssignment < ActiveRecord::Base

  belongs_to :feature
  belongs_to :feature_assignable, :polymorphic => true
end
