module Api::V1
  class ApiController < Api::ApplicationController
    include Api::V1::ResponseRenderers

  end
end