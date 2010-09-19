tags = '"wow its a phrase" blahhahaha wow "another phrase" jeez'
phrases = tags.scan(/(\".*?\")/).flatten
singles = tags.gsub(Regexp.new(phrases.join("|")), "").gsub(/ +/, " ").split(" ")
phrases = phrases
sanitized_tags = (singles+phrases).join(",")