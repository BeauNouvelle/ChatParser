#ChatParser
Extracts mentions, links and emoticons from any string of text you may have in a chat app, and returns that data as a JSON string.

Fully tested and documented API.

##Example Project##
Download the source code and run the example app to see ChatParser in action.

![screenshot](https://raw.githubusercontent.com/BeauNouvelle/ChatParser/release/V1.0.0/ChatParser/Example/examplescreen.png)

##Usage##
After linking the *ChatParser.framework* to your app you can start parsing your chat text using a single function.


``` 
func textFieldShouldReturn(textField: UITextField) -> Bool {
    ChatParser().extractContent(.Any, fromString: textField.text!) { (prettyJSON) -> () in
        if let prettyJSON = prettyJSON {
            self.outputTextView.text = prettyJSON
        }
    }
    return true
}
    
```

You should then end up with an output like this:

```
{
   "emoticons" :[
      "heart"
   ],
   "links" : [
      {
         "title" : "Beau Nouvelle",
         "url" : "https:\/\/beaunouvelle.com"
      }
   ],
   "mentions" : [
      "Beau"
   ]
}
```

###Content###
**.Mentions** - Extracts any words with an "@" prefix. Will safely ignore email schemes.

**.Emoticons** - Extracts any emoticons that fit the format of a word encapsulated in parenthesis.


**.Links** - Extracts URLS and their web page titles. Requires a web request in order to fetch page titles so there can be a delay when extracting this content type.

**.Any** - Extracts all and any of the above.

You can also use a combination of any of the above like so:

```
ChatParser().extractContent(.Mention, .Links, fromString: textField.text!) { (prettyJSON) -> () in
}
```
