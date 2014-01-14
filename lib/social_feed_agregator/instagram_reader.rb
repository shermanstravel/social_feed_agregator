require 'social_feed_agregator/base_reader'
require 'social_feed_agregator/feed'
require 'instagram'

module SocialFeedAgregator
  class InstagramReader < BaseReader

    attr_reader :client, :username

    def initialize(options={})
      super(options)
      options.replace(SFA.default_options.merge(options))
      @username = options[:instagram_username]
      ::Instagram.configure do |c|
        c.client_id = options[:instagram_client_id]
        c.access_token = options[:instagram_access_token]
      end
      @client = ::Instagram
    end

    def get_feeds(options={})
      # retreive options
      super(options)
      number_of_feeds_requested = options.fetch(:count, 25)
      user = search_user(options.fetch(:name, username))
      data, feed_data = nil, []

      return [] if user.nil?

      # fetch data from webserver
      while feed_data.size < number_of_feeds_requested
        data = more_data(user, data)
        feed_data.concat(data)
      end

      # send data to the resolver
      return feed_data.take(number_of_feeds_requested).map do |feed_item|
        feed = fill_feed(feed_item)
        yield(feed) if block_given?
        feed
      end
    end


    private

    # search_user - convets a given username into a user id
    def search_user(username)
      return client.user_search(username).try(:[], 0).try(:[], 'id')
    end

    def more_data(user, last_data_request)
      next_page = last_data_request.try(:pagination).try(:next_max_id)
      return client.user_recent_media(user, :max_id => next_page)
    end

    def fill_feed(item)
      Feed.new(:feed_type => :instagram,
        :feed_id => item['id'],
        :user_id => item['user']['id'],
        :user_name => item['user']['full_name'],
        :permalink => item['link'],
        :picture_url => item['images']['low_resolution']['url'],
        :description => item['caption']['text'],
        :type => item['type'],
        :link => item['link'],
        :name => item['filter'],
        :caption => item['tags'].join(', '),
        :created_at => Time.at(item['created_time'].to_i)
      )
    end

  end
  Instagram = InstagramReader
end