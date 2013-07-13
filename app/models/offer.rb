class Offer
  attr_reader :title, :payout, :thumbnail

  FIXED_PARAMS = {
    appid: 157
  }

  def initialize(attributes={})
    @title = attributes[:title]
    @payout = attributes[:payout]
    @thumbnail = attributes[:thumbnail]
  end

  def self.where(params)
    response = RestClient.get(Settings.api_url, params: params.merge(FIXED_PARAMS))

    return [] if response.to_str.empty?

    body = JSON.parse(response.to_str)

    body['offers'].map do |offer|
      Offer.new title: offer['title'], payout: offer['payout'], thumbnail: offer['thumbnail']['lowres']
    end
  end
end
