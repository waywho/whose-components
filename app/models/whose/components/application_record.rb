module Whose
  module Components
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
