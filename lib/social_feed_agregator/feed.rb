module SocialFeedAgregator
  class Feed

    attr_accessor :feed_type,
      :feed_id,
      :user_id,
      :user_name,
      :permalink,
      :description,
      :picture_url,
      :name,
      :link,
      :message,
      :caption,
      :created_at,
      :type

    def initialize(options={})
      @feed_type = options[:feed_type]
      @feed_id =   options[:feed_id]

      @user_id =   options[:user_id]
      @user_name = options[:user_name]

      @permalink =   options[:permalink]
      @description = options[:description]
      @picture_url = options[:picture_url]

      @name  = options[:name]
      @link  = options[:link]
      # @story = options[:story]
      @message = options[:message]
      @caption = options[:caption]
      @created_at = options[:created_at]
      @type = options[:type]
    end

    def attributes
      instance_variables.inject({}) { |r, a| r[a.to_s.gsub("@","")] = instance_variable_get(a).to_s; r }
    end

  end
end