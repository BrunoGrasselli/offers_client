class OffersClient < Sinatra::Base
  get "/" do
    erb :form
  end

  get "/offers" do
    params.inspect
  end
end
