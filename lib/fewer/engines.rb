module Fewer
  module Engines
    autoload :Abstract, 'fewer/engines/abstract'
    autoload :Css,      'fewer/engines/css'
    autoload :Js,       'fewer/engines/js'
    autoload :JsMin,    'fewer/engines/js_min'
    autoload :Less,     'fewer/engines/less'
  end
end
