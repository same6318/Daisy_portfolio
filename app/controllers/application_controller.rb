class ApplicationController < ActionController::Base

    #ハンドルしきれなかったエラーは500エラー扱い
  # if !Rails.env.development?
  #   rescue_from Exception,                        with: :render_500
  #   rescue_from ActiveRecord::RecordNotFound,     with: :render_404
  #   rescue_from ActionController::RoutingError,   with: :render_404
  # end

  # def routing_error
  #   raise ActionController::RoutingError.new(params[:path])
  # end

  # def render_404(e = nil)
  #   logger.info "Rendering 404 with exception: #{e.message}" if e

  #   if request.xhr?
  #     render json: { error: '404 error' }, status: 404
  #   else
  #     format = params[:format] == :json ? :json : :html
  #     render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
  #   end
  # end  
end
