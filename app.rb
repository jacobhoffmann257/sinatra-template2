require "sinatra"
require "sinatra/reloader"
require "http"
require "sinatra/cookies"
require "json"
require "better_errors"
require "binding_of_caller"


get("/") do
  erb(:home)
end
get("/search") do
  erb(:search)
end
post("/bookresult") do
rawtitle = params.fetch("isbn")
if(rawtitle.class == String)
  puts rawtitle
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
if (olparsed.has_key?("description"))
@description = olparsed.fetch("description")
else
  @description = "Couldn't find a description for that book"
end
#trying spilting the description if the is something like east of eden
authors = olparsed.fetch("authors")
authorhash = authors[0]
authorloc = authorhash.fetch("author")
authorkey = authorloc.fetch("key")
authorurl = "https://openlibrary.org#{authorkey}.json"
authorraw = HTTP.get(authorurl)

authorparsed = JSON.parse(authorraw)
if(authorparsed.has_key?("doc"))
@authorbio = authorparsed.fetch("doc")
else
@authorbio = "This author doesn't have a bio here"
end
authorname = authorparsed.fetch("personal_name")
splited = authorname.split(",")
@firstname = splited[1]
@lastname = splited[0]
erb(:bookresult)
  
else
  erb(:failure)
end

else
  erb(:failure)
end
end
