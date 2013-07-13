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
    response = RestClient.get(Settings.api_url, params: generate_params(params))

    return [] if response.to_str.empty?

    body = JSON.parse(response.to_str)

    body['offers'].map do |offer|
      Offer.new title: offer['title'], payout: offer['payout'], thumbnail: offer['thumbnail']['lowres']
    end
  end

  def self.generate_params(params)
    params.tap do |final_params|
      final_params.merge!(FIXED_PARAMS)
      final_params[:hash_key] = authentication_hash.request_hash(final_params)
    end
  end

  def self.authentication_hash
    OffersSDK::AuthenticationHash.new(Settings.api_key)
  end
end
