class Offer
  attr_reader :title, :payout, :thumbnail

  def initialize(attributes={})
    @title = attributes[:title]
    @payout = attributes[:payout]
    @thumbnail = attributes[:thumbnail]
  end

  def self.where(params)
    response = RestClient.get 'http://localhost:3000/offers.json', params: params

    return '' if response.to_str.empty?

    body = JSON.parse(response.to_str)

    body['offers'].map do |offer|
      Offer.new title: offer['title'], payout: offer['payout'], thumbnail: offer['thumbnail']['lowres']
    end
  end
end
