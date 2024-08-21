require 'net/http'
require 'json'
require 'uri'

module WebhookHelper
    def send_discord_message_for_new_post(webhookUrl, post, user)
        uri = URI.parse(webhookUrl)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")
        request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' => 'application/json'})
        
        # Set the request body
        request.body = {
            "embeds": [
                {
                    "title": "New Feedback Submitted",
                    "url": "#{Rails.application.base_url}/posts/#{post.slug}",
                    "color": 2666766,
                    "fields": [
                        {
                            "name": "Title",
                            "value": "#{post.title}"
                        },
                        {
                            "name": "Description",
                            "value": "#{post.description[0..500]}#{post.description.length > 500 ? '...' : ''}"
                        },
                        {
                            "name": "View/Upvote",
                            "value": "#{Rails.application.base_url}/posts/#{post.slug}"
                        }
                    ],
                    "author": {
                        "name": "#{user ? user.full_name : 'Anonymous User'}",
                        "icon_url": "#{user ? user.gravatar_url : 'https://secure.gravatar.com/avatar/000000000000000000000000000000000000000000000000000000?default=mp' }"
                    }
                }
            ]
        }.to_json
        
        # Send the request
        response = http.request(request)
        
        return response.code == "204"
    end
end