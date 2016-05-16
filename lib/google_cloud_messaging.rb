require 'google_cloud_messaging/version'
require 'typhoeus'
require 'json'

#module GoogleCloudMessaging

  class GCM

    attr_accessor :base_uri

    attr_reader :body
    attr_reader :code
    attr_reader :raw

    attr_reader :results
    attr_reader :successes
    attr_reader :canonicals
    attr_reader :errors

    def initialize(key, options = {})

      options = options || {}

      @key = key
      @base_uri = options[:base_uri] || 'https://gcm-http.googleapis.com/gcm/send'

      # TODO: allow user to pass in their own Typhoeus object...

    end

    class Result

      attr_reader :id
      attr_reader :data
      attr_reader :message_id
      attr_reader :error
      attr_reader :registration_id

      def initialize(opts)
        @id = opts[:id]
        @data = opts[:data]
        @message_id = opts[:message_id]
        @error = opts[:error]
        @registration_id = opts[:registration_id]
      end

    end

    def send(data, tokens)

      data['registration_ids'] = tokens

      request = Typhoeus::Request.new(
        @base_uri,
        method: :post,
        body: data.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "key=#{@key}"
        }
      )

      @code = nil
      @raw = nil
      @body = nil

      @results = []
      @successes = []
      @canonicals = []
      @errors = []

      request.run

      @raw = got = request.response
      @code = got.code

      if got.code == 200

        @body = data = JSON.parse(got.response_body) if got.response_body

        gres = data['results'] || []

        (0..(gres.length-1)).each { |idx|

          result = gres[idx]
          token = tokens[idx]

          @results << Result.new(id: token, data: result)

          if result['message_id']

            @successes << Result.new(id: token, message_id: result['message_id'])

          elsif result['error']

            @errors << Result.new(id: token, error: result['error'])

          elsif result['registration_id']

            @canonicals << Result.new(id: token, registration_id: result['registration_id'])

          end

        }

      end

      @body

    end
  end
#end
