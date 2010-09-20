def sanitize_tags(tags)
  phrases = tags.scan(/(\".*?\")/).flatten
  singles = tags.gsub(Regexp.new(phrases.join("|")), "").gsub(/ +/, " ").split(" ")
  return (singles+phrases).join(",")
end
