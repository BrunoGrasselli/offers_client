require 'spec_helper'
require 'webmock'
include WebMock::API

describe Offer do
  describe "#where" do
    before do
      stub_request(:get, "http://localhost:3000/offers.json?appid=157&page=2&pub0=campaign1&uid=12").to_return(body: body, status: status)
    end

    context "when api returns offers" do
      let(:status) { 200 }
      let(:body) { %(
        {
          "offers": [
            {
              "title":"title1",
              "payout":200,
              "thumbnail": {
                "lowres": "http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_60.png"
              }
            },
            {
              "title":"title2",
              "payout":300,
              "thumbnail": {
                "lowres": "http://cdn.sponsorpay.com/assets/9999/icon175x175-2_square_60.png"
              }
            }
          ]
        }
      ) }

      it "returns offers" do
        offers = Offer.where(uid: 12, pub0: 'campaign1', page: 2)

        offers[0].payout.should eq 200
        offers[0].thumbnail.should eq 'http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_60.png'
        offers[0].title.should eq 'title1'

        offers[1].payout.should eq 300
        offers[1].thumbnail.should eq 'http://cdn.sponsorpay.com/assets/9999/icon175x175-2_square_60.png'
        offers[1].title.should eq 'title2'
      end
    end

    context "when api doesn't return offers" do
      let(:status) { 200 }
      let(:body) { '' }

      it "returns an empty array" do
        offers = Offer.where(uid: 12, pub0: 'campaign1', page: 2)
        offers.should eq []
      end
    end
  end
end

