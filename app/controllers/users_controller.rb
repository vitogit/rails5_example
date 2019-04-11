class UsersController < ApplicationController
  def payment

    payment = Payment.new(amount: valid_params[:amount], 
                   sender_id: valid_params[:id], 
                   receiver_id: valid_params[:friend_id], 
                   description: valid_params[:description])
    if payment.save
      json_response({ message: 'Success' })
    else
      json_response({ message: payment.errors }, 400)
    end

  end

  private

  def valid_params
    # whitelist params
    params.permit(:id, :friend_id, :amount, :description)
  end
  
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
