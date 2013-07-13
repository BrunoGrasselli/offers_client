require './config/boot'

use Rack::Static, urls: ['/stylesheets', '/javascripts'], root: 'public'

run OffersClient
