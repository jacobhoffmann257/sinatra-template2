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
isbn = params.fetch("isbn")
libraryurl = "https://openlibrary.org/works/#{isbn}.json"
rawresponse = HTTP.get(libraryurl)
parsedresponse = JSON.parse(rawresponse)
@title = parsedresponse.fetch("title")
@author = parsedresponse.fetch("authors")
@description = parsedresponse.fetch("description")
@places = parsedresponse.fetch("subject_places")
@subjects = parsedresponse.fetch("subjects")
@people = parsedresponse.fetch("subject_people")
@times = parsedresponse.fetch("subject_times")
@location = parsedresponse.fetch("location")
@created = parsedresponse.fetch("created")

puts @places
erb(:bookresult)
end
