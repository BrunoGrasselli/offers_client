require 'spec_helper'

describe "Searching for offers" do
  before do
    url = "http://localhost:3000/offers.json?appid=157&device_id=2b6f0cc904d137be2%20e1730235f5664094b%20831186&hash_key=7943a8cce286c7e974a34eb9b6d79a7ce806ec47&ip=109.235.143.113&locale=de&offer_types=112&page=1&pub0=campaign_2&uid=1234"
    stub_request(:get, url).to_return(body: body, status: status, headers: { 'X-Sponsorpay-Response-Signature' => signature })
  end

  context "when there are offers" do
    let(:status) { 200 }
    let(:signature) { 'ffcfb6386abe0643310487de4e09ab6a25f40bde' }
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

    it "lists offers" do
      visit '/'

      fill_in "User Id", with: "1234"
      fill_in "Pub0", with: "campaign_2"
      fill_in "Page", with: "1"

      click_button "Search"

      page.should have_content "title1"
      page.should have_content "200"

      page.should have_content "title2"
      page.should have_content "300"

      page.should_not have_content 'No offers'
    end
  end

  context "when there aren't offers" do
    let(:status) { 200 }
    let(:signature) { 'fabe540778d200b7f93b2710b39939dc267e4294' }
    let(:body) { '' }

    it "doesn't list offers", js: true do
      visit '/'

      fill_in "User Id", with: "1234"
      fill_in "Pub0", with: "campaign_2"
      fill_in "Page", with: "1"

      click_button "Search"

      page.should_not have_content "title1"
      page.should have_content 'No offers'
    end
  end
end

