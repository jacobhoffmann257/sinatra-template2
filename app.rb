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
numFound = thetitleparsed.fetch("numFound")
pp numFound
if(thetitleparsed.fetch("numFound") >= 1)
docs = thetitleparsed.fetch("docs")
titledocs = docs[0]
olkey = titledocs.fetch("key")
#https://openlibrary.org/works/OL45804W.json
olurl = "https://openlibrary.org#{olkey}.json"
olraw = HTTP.get(olurl)
olparsed = JSON.parse(olraw)
@title = olparsed.fetch("title")
@description = olparsed.fetch("description")
#trying spilting the description if the is something like east of eden
authors = olparsed.fetch("authors")
authorhash = authors[0]
authorloc = authorhash.fetch("author")
authorkey = authorloc.fetch("key")
#typeloc = authorhash.fetch("type")
#lockey = typeloc.fetch("key")
authorurl = "https://openlibrary.org#{authorkey}.json"
authorraw = HTTP.get(authorurl)

authorparsed = JSON.parse(authorraw)
#pp authorparsed
if(authorparsed.has_key?("doc"))
@authorbio = authorparsed.fetch("doc")
else
@authorbio = "No bio found"
end
authorname = authorparsed.fetch("personal_name")
splited = authorname.split(",")
@firstname = splited[1]
@lastname = splited[0]
#puts authordoc.class
erb(:bookresult)
  
else
  erb(:failure)
end
end
