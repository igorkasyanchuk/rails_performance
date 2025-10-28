class Worker3 < Grape::API
  desc "Make crash"
  get :crash do
    1 / 0
  end

  desc "Make no content with content"
  get :no_content_with_content do
    status 204
    "No Content"
  end

  desc "Make no content"
  get :no_content do
    status 204
  end

  desc "Make conflict"
  get :conflict do
    status 409
    error!("Conflict", 409)
  end

  desc "Make unprocessable entity"
  get :unprocessable_entity do
    status 422
    error!("Unprocessable Entity", 422)
  end

  desc "Make internal server error"
  get :internal_server_error do
    status 500
    error!("Internal Server Error", 500)
  end
end
