module Api
	module ResponseRenderers
		extend ActiveSupport::Concern

		class_methods do

		  # Renders formatted error response with validation messages
		  #
		  # @param error The error message to return.
		  # @param record ActiveRecord record object
		  # @param http_status The http status to use.
		  # @param payload The optional payload.
		  #
		  def render_api_error_response_with_full_messages(error, record, http_status = :ok, payload = {})
		    if record and record.respond_to?(:errors) and record.errors.any?
		      error[:message] = record.errors.full_messages.join(' ')
		    end
		    render_api_error_response(error, http_status, payload)
		  end

		  # Renders formatted error response
		  #
		  # @param error The error message to return.
		  # @param http_status The http status to use.
		  # @param payload The optional payload.
		  #
		  def render_api_error_response(error, http_status = :ok, payload = {})
		    render_api_response(response_attrs(
		      status: 'failure',
		      data: response_data(payload.merge(errors: [ error ]))
		    ), http_status)
		  end

		  # Renders formatted success response
		  #
		  # @param payload The optional payload.
		  # @param http_status The http status to use.
		  #
		  def render_api_success_response(payload = {}, http_status = :ok)
		    render_api_response(response_attrs(
		      status: 'success',
		      data: payload.is_a?(Hash) ? response_data(payload) : payload
		    ), http_status)
		  end

		  # Renders formatted response
		  #
		  # @param payload The optional payload.
		  # @param http_status The http status to use.
		  #
		  def render_api_response(payload = {}, http_status = :ok)
		    render json: payload, status: http_status
		  end

		end

	end
end