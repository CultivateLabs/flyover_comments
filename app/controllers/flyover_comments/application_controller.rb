module FlyoverComments
  class ApplicationController < FlyoverComments.application_controller_superclass

    def _foc_authorize(record, action = nil)
      authorize(record, action) if Object.const_defined?("Pundit") && policy(record)
    end

  end
end
