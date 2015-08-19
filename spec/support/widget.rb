class Widget < Struct.new(:description)
  include FlyoverComments::LinkParsing
  include FlyoverComments::Authorization
end