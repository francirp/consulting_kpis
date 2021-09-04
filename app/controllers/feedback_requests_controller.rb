class FeedbackRequestsController < ApplicationController
  before_action :load_feedback_request, only: [:show, :update]
  skip_before_action :authenticate_user!

  def show
    rating = params[:rating].try(:to_i)
    return render :token_not_found unless rating 
    @feedback_request.update_attribute(:rating, rating)
    render :show
  end

  def update
    if @feedback_request.update(feedback_request_params)
      redirect_to success_feedback_requests_path
    else
      render :show
    end
  end

  def success
  end

  private

  # Load the reponse by token, if it's not found, then 
  # render the token_not_found template
  def load_feedback_request
    @feedback_request = FeedbackRequest.find_by(token: params[:id])
    return render :token_not_found if @feedback_request.nil?
  end

  def feedback_request_params
    FeedbackRequestDecanter.decant(params[:feedback_request])
  end  
end