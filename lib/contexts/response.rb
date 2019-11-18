module Context
  class Response
    
    def initialize(message, error = nil, status = :ok)
      @message = message
      @error   = error
      @status  = status
    end

    def perform
      @error ? {json: {message: @message, error: @error}, status: @status} : {json: @message, status: @status}
    end
  end
end

