class User < ActiveRecord::Base
  attr_accessible :facebook_id, :access_token
end
