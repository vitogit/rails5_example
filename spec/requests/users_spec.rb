require "rails_helper"

RSpec.describe "Users API", type: :request do
  let!(:user_1) { create(:user, name: "user_1") }
  let!(:user_2) { create(:user, name: "user_2") }

  describe "POST /user/{id}/payment" do
    # user_1 and user_2 are friends
    before { user_1.friends << user_2 } 

    context "with valid params" do
      before { post "/user/#{user_1.id}/payment", params: { friend_id: user_2.id, amount: 100, description: "Yeah" } }
      it "returns status code 200 with empty body" do
        expect(response).to have_http_status(200)
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
      before { post "/user/#{user_1.id}/balance"}
      it "returns status code 200 with empty body" do
        expect(response).to have_http_status(200)
      end
      it "returns the correct amount" do
        expect(response.body).to match(/1000.0/)
      end
    end

    context "with invalid user" do
      before { post "/user/#{user_1.id+10}/balance" }

      it "returns status code 400" do
        expect(response).to have_http_status(400)
      end

      it "returns a error message" do
        expect(response.body).to match(/Invalid params/)
      end
    end
  end
end
