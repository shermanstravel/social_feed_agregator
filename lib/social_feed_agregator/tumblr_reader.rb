require "social_feed_agregator/base_reader"
require "social_feed_agregator/feed"
require 'tumblr_client'

module SocialFeedAgregator
  class TumblrReader < BaseReader

    attr_reader :client, :target_blog

    def initialize(options={})
      super(options)
      options.replace(SFA.default_options.merge(options))
      @target_blog = options[:tumblr_url]
      @client = ::Tumblr::Client.new({
        :consumer_key => options[:tumblr_consumer_key],
        :consumer_secret => options[:tumblr_consumer_secret],
        :oauth_token => options[:tumblr_oauth_token],
        :oauth_token_secret => options[:tumblr_oauth_token_secret]
      })
    end

    def get_feeds(options={})
      # retreive options
      super(options)
      number_of_feeds_requested = options.fetch(:count, 25)
      blog = options.fetch(:name, target_blog)
      return [] if blog.nil?

      feed_data = client.posts(blog)

      # send data to the resolver
      return feed_data['posts'].take(number_of_feeds_requested).map do |feed_item|
        feed = fill_feed(feed_item)
        yield(feed) if block_given?
        feed
      end
    end


    private


    def fill_feed(item)
      if item['type'] == 'photo'
        Feed.new(:feed_type => :tumblr,
          :feed_id => item['id'],
          :user_name => item['blog_name'],
          :permalink => item['post_url'],
          :picture_url => item['photos'][0]['original_size']['url'],
          :image_permalink => item['image_permalink'],
          :type => item['type'],
          :link => item['permalink_url'],
          :name => item['slug'],
          :caption => item['caption'],
          :created_date => Time.at(item['timestamp'].to_i)
        )
      elsif item['type'] == 'video'
        Feed.new(:feed_type => :tumblr,
          :feed_id => item['id'],
          :user_name => item['blog_name'],
          :permalink => item['post_url'],
          :picture_url => item['thumbnail_url'],
          :type => item['type'],
          :link => item['permalink_url'],
          :name => item['slug'],
          :caption => item['player'].first["embed_code"],
          :created_date => Time.at(item['timestamp'].to_i)
        )
      end
    end

  end
  Tumblr = TumblrReader
end