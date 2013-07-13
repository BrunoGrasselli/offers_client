require 'spec_helper'
require 'webmock'
include WebMock::API

describe Offer do
  describe "#where" do
    let(:status) { 200 }
    let(:body) { '' }
    let(:signature) { 'fabe540778d200b7f93b2710b39939dc267e4294' }

    before do
      api_key = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'
      authentication_hash = OffersSDK::AuthenticationHash.new(api_key)
      authentication_hash.stub(:request_hash).with(anything).and_return(1234)
      OffersSDK::AuthenticationHash.stub(:new).with(api_key).and_return(authentication_hash)
      url = "http://localhost:3000/offers.json?appid=157&device_id=2b6f0cc904d137be2%20e1730235f5664094b%20831186&hash_key=1234&ip=109.235.143.113&locale=de&offer_types=112&page=2&pub0=campaign1&uid=12"
      stub_request(:get, url).to_return(body: body, status: status, headers: { 'X-Sponsorpay-Response-Signature' => signature })
    end

    after do
      OffersSDK::AuthenticationHash.unstub(:new)
    end

    context "when api returns offers" do
      let(:signature) { 'c73a6f3959d59d8a8b3fd90cc23e666defd451ef' }
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
      let(:body) { '' }

      it "returns an empty array" do
        offers = Offer.where(uid: 12, pub0: 'campaign1', page: 2)
        offers.should eq []
      end
    end

    it "sends all parameters to generate the auth hash" do
      api_key = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'
      authentication_hash = OffersSDK::AuthenticationHash.new(api_key)
      authentication_hash.should_receive(:request_hash).with({:uid=>12, :pub0=>"campaign1", :page=>2, :appid=>157, :offer_types=>112, :device_id=>"2b6f0cc904d137be2 e1730235f5664094b 831186", :locale=>"de", :ip=>"109.235.143.113"}).and_return(1234)
      OffersSDK::AuthenticationHash.stub(:new).with(api_key).and_return(authentication_hash)
      Offer.where(uid: 12, pub0: 'campaign1', page: 2)
    end

    context "when response signature is invalid" do
      let(:signature) { 'invalid' }

      it "raises error" do
        expect { Offer.where(uid: 12, pub0: 'campaign1', page: 2) }.to raise_error Offer::InvalidResponseSignature
      end
    end
  end
end

