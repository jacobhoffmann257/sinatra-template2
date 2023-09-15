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
rawtitle = params.fetch("isbn")
thetitle = rawtitle.gsub(" ", "+")
thetitleurl = "https://openlibrary.org/search.json?title=#{thetitle}"
thetitleraw = HTTP.get(thetitleurl)
thetitleparsed = JSON.parse(thetitleraw)
docs = thetitleparsed.fetch("docs")
titledocs = docs[0]
olkey = titledocs.fetch("key")
#https://openlibrary.org/works/OL45804W.json
olurl = "https://openlibrary.org#{olkey}.json"
olraw = HTTP.get(olurl)
olparsed = JSON.parse(olraw)
title = olparsed.fetch("title")
description = olparsed.fetch("description")
authors = olparsed.fetch("authors")
authorhash = authors[0]
authorloc = authorhash.fetch("author")
authorkey = authorloc.fetch("key")
#typeloc = authorhash.fetch("type")
#lockey = typeloc.fetch("key")
authorurl = "https://openlibrary.org#{authorkey}.json"
authorraw = HTTP.get(authorurl)
authorparsed = JSON.parse(authorraw)
authorbio = authorparsed.fetch("bio")
authorname = authorparsed.fetch("personal_name")
puts authorname
#puts authordoc.class
erb(:bookresult)
end
