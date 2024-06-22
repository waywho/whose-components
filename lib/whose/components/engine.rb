module Whose
  module Components
    class Engine < ::Rails::Engine
      isolate_namespace Whose::Components
    end
  end
end
