require 'spec_helper'

describe OffersClient do
  let(:app) { described_class }
  
  describe "/ with GET" do
    it "returns status code 200" do
      get '/'
      last_response.status.should eq 200
    end
  end

  describe "/offers with GET" do
    before do
      Offer.stub(:where).with(anything).and_return([])
    end

    after do
      Offer.unstub(:where)
    end

    it "returns status code 200" do
      get '/offers'
      last_response.status.should eq 200
    end

    context "when the search returns offers" do
      before do
        offer = Offer.new title: 'My offer', payout: 13, thumbnail: 'myimage.png'
        Offer.stub(:where).with({'uid' => '10', 'pub0' => 'campaign', 'page' => '3'}).and_return([offer])
      end

      it "lists the offers" do
        get '/offers', offer: {uid: 10, pub0: 'campaign', page: 3}

        last_response.body.should include 'My offer'
        last_response.body.should include '13'
        last_response.body.should include 'myimage.png'
      end

      it "doesn't display the 'No offers' message" do
        get '/offers', offer: {uid: 10, pub0: 'campaign', page: 3}
        last_response.body.should_not include 'No offers'
      end
    end

    context "when the search doesn't return offers" do
      before do
        Offer.stub(:where).with({'uid' => '10', 'pub0' => 'campaign', 'page' => '3'}).and_return([])
      end

      it "displays the 'No offers' message" do
        get '/offers', offer: {uid: 10, pub0: 'campaign', page: 3}
        last_response.body.should include 'No offers'
      end
    end
  end
end

