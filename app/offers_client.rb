class OffersClient < Sinatra::Base
  get "/" do
    erb :form
  end

  get "/offers" do
    offers = Offer.where(params[:offer])
    erb :offers, locals: {offers: offers}
  end
end
