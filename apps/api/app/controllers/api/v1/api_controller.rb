module Api::V1
  class ApiController < Api::ApplicationController

    include Api::ResponseRenderers
    include Api::SwaggerDocs

  end
end