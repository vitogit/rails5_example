require "rails_helper"

RSpec.describe "Users API", type: :request do
  let!(:user_1) { create(:user, name: "user_1") }
  let!(:user_2) { create(:user, name: "user_2") }
  let!(:payment_account_1){ create(:payment_account, balance: 150, user_id: user_1.id) }
  let!(:payment_account_2){ create(:payment_account, balance: 100, user_id: user_2.id) }
  describe "POST /user/{id}/payment" do
    before { user_1.friends << user_2 } 

    context "with valid params" do
      it "returns status code 200 with empty body and modify the balance" do
        post "/user/#{user_1.id}/payment", params: { friend_id: user_2.id, amount: 100, description: "Yeah" }
        expect(response).to have_http_status(200)
        expect(user_1.payment_account.balance).to eq 50
        expect(user_2.payment_account.balance).to eq 200
      end

      it "transfer the needed money from an external balance if balance < 0" do
        post "/user/#{user_1.id}/payment", params: { friend_id: user_2.id, amount: 200, description: "Yeah" }
        expect(user_1.payment_account.balance).to eq 0
        expect(user_2.payment_account.balance).to eq 300
      end
    end

    context "with invalid friend" do
      before { post "/user/#{user_1.id}/payment", params: { friend_id: user_2.id+10, amount: 100, description: "Yeah" } }

      it "returns status code 400" do
        expect(response).to have_http_status(400)
      end

      it "returns a not found friend message" do
        expect(response.body).to match(/Receiver is not a friend of Sender/)
      end
    end
    
    context "with invalid amount" do
      before { post "/user/#{user_1.id}/payment", params: { friend_id: user_2.id, amount: 20000, description: "Yeah" } }

      it "returns status code 400" do
        expect(response).to have_http_status(400)
      end

      it "returns a invalid range number for amount" do
        expect(response.body).to match(/must be less than 1000/)
      end
    end
  end

  describe "Get /user/{id}/balance" do
    let!(:payment_account) { create(:payment_account, user_id: user_1.id, balance: 1000) }

    context "with valid params" do
      before { get "/user/#{user_1.id}/balance"}
      it "returns status code 200 with empty body" do
        expect(response).to have_http_status(200)
      end
      it "returns the correct amount" do
        expect(response.body).to match(/1000.0/)
      end
    end

    context "with invalid user" do
      before { get "/user/#{user_1.id+10}/balance" }

      it "returns status code 400" do
        expect(response).to have_http_status(400)
      end

      it "returns a error message" do
        expect(response.body).to match(/Invalid params/)
      end
    end
  end
  
  describe "Get /user/{id}/feed" do
    before { user_1.friends << user_2 } 
    before { user_2.friends << user_1 } 

    let!(:feed_list) { create_list(:payment, 12, sender_id: user_1.id, receiver_id: user_2.id, amount: 1, description: 'test description') }
    context "with valid params" do
      before { get "/user/#{user_1.id}/feed"}
      it "returns status code 200 with empty body" do
        expect(response).to have_http_status(200)
      end
      it "returns 10 payments as the first page" do
        parsed_response = JSON.parse(response.body)
        feed = parsed_response['feed']
        expect(feed.size).to eq 10
      end

      it "first feed item has the correct format" do
        parsed_response = JSON.parse(response.body)
        feed = parsed_response['feed']
        first_feed = feed.first
        expect(first_feed['title']).to eq "#{user_1.name} paid #{user_2.name} on #{feed_list.last.created_at}. test description"
      end
    end

    context "with page param" do
      before { get "/user/#{user_1.id}/feed", params: { page: 2} }
      
      it "returns 2 payments in the feed as the second page" do
        parsed_response = JSON.parse(response.body)
        feed = parsed_response['feed']
        expect(feed.size).to eq 2
      end
    end

    context "include user and other user payments in the feed" do
      let!(:single_payment) { create_list(:payment, 5, sender_id: user_2.id, receiver_id: user_1.id, amount: 1, description: 'test description') }
      before do
        get "/user/#{user_1.id}/feed", params: { page: 2}
      end

      it "returns payments from current and other users" do
        parsed_response = JSON.parse(response.body)
        feed = parsed_response['feed']
        expect(feed.size).to eq 7
      end
    end

  end
end
