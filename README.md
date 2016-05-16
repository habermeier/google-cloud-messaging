# GoogleCloudMessaging

## Installation

Add this line to your application's Gemfile:

    gem 'google_cloud_messaging'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install google_cloud_messaging

## Why this?

I wanted to just use the **gcm** gem, but it didn't work.  After scratching my head a while, I saw that
sending *Google Cloud Message* requests is easy.

The **gcm** gem also uses *HTTParty* which I'm not a huge fan of from past experiences.

So I ended up writing this very minimal wrapper using *Typhoeus*.  Perhaps one day we'll extend this to allow the
  user to pass in their
  own hydra.  That would be nice in case you want to do other things in parallel.  For now this is all I needed.

This gem trivially helps with Google dealing with the results from Google API Service.

## Usage

```
require	'google_cloud_messaging'

key = '<your Google server key here>'

ids =  [
  "<some device registration id 1>",
  "<some device registration id 2>",
  "<...>",
  "<some device registration id N>",
]

gcm = GCM.new(key)
gcm.send({ data: { message: 'hi there!' } }, ids)

if gcm.code == 200

  puts "Messages Sent:"
  gcm.successes.each { |item|
    puts "ok: #{item.id}, message_id: #{item.message_id}"
  }

  puts "Canonical Tokens:"
  gcm.canonicals.each { |item|
    puts "swap: #{item.id}, with: #{item.registration_id}"
  }

  puts "Errors:"
  gcm.errors.each { |item|
    puts "bad: #{item.id}, error: #{item.error}"
  }

  puts "Everything:"
  gcm.results.each { |item|
    puts "#{item.id}, raw: #{item.data}"
  }

else

  puts "very sad.  We got: #{gcm.code}"
  puts "Here is the sad truth:"
  puts "#{gcm.raw.response_body}"

end


```

While Google servers present an array of results (which you can work with directly from the gcm.raw field), for it
to be useful you need to find the originating registration_id so you know what the response is in reference to.  This
gem makes this a little easier for you, because it breaks out the results for you, and includes the id back for you:

Assuning this call succeeds:

`gcm.send({ data: { ... }, [id1, id2, id3, ...])`

Then the following gcm attributes contain **array of Result objects** each with the indicated attributes set:

| gcm field     | attributes | purpose |
|-------------------|------------|------------|
| **`gcm.successes`** | `id, message_id` | This array contains all successful push notifications as reported by Google |
| **`gcm.canonicals`** | `id, registration_id` | This array contains all canonical ids that you should switch out as reported by Google|
| **`gcm.errors`** | `id, error` |This array contains all errors as reported by Google |
| **`gcm.results`** | `id, data` |This array contains all data for each registration id exactly as reported by Google |

## Testing

Testing this gem is kinda hard, because we need to generate a server API key and have Android clients that can produce
valid push tokens.  So the only test case I have is a laughable permission denied test.  One way around this
might be to record real data from a session and then inject this data and use that as test data instead of making the
network call.  But you know... that'd be way more code than the actual gem here.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/google_cloud_messaging/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
