class UsersController < ApplicationController
  def payment
    payment = Payment.new(amount: payment_params[:amount], 
                   sender_id: payment_params[:id], 
                   receiver_id: payment_params[:friend_id], 
                   description: payment_params[:description])
    if payment.save
      json_response({})
    else
      json_response({ message: payment.errors }, 400)
    end

  end

  def balance
    user = User.find_by(id: balance_params[:id])
    if user && user.payment_account
      json_response({ amount: user.payment_account.balance })
    else
      json_response({ message: 'Invalid params' }, 400)
    end
  end

  def feed
    user = User.find(feed_params[:id])
    page = feed_params[:page]
    feed = user.feed(page)
    if feed
      json_response({ feed: feed })
    else
      json_response({ message: 'Invalid params' }, 400)
    end
  end

  private
  # whitelist params
  def payment_params
    params.permit(:id, :friend_id, :amount, :description)
  end

  def feed_params
    params.permit(:id, :page)
  end

  def balance_params
    params.permit(:id)
  end
  
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
