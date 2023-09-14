require "sinatra"
require "sinatra/reloader"
require "http"
require "sinatra/cookies"
require "json"
require "better_errors"
require "binding_of_caller"
use(BetterErrors::Middleware)
BetterErrors.application_root = __dir__
BetterErrors::Middleware.allow_ip!('0.0.0.0/0.0.0.0')

get("/") do
  erb(:home)
end
get("/search") do
  erb(:search)
end
post("/bookresult") do 
erb(:bookresult)
end
