require 'nokogiri'
require 'httpclient'
require 'json'

class ImportLink
  TWITTER_URL_RE = '^https?://(x|twitter).com/'
  GET_TWEETS_URL = 'https://twitter.com/i/api/graphql/XicnWRbyQ3WgVY__VataBQ/UserTweets'
  GET_TWEET_URL = 'https://api.twitter.com/graphql/5GOHgZe-8U2j5sVHQzEm9A/TweetResultByRestId'
  GET_USER_URL = 'https://twitter.com/i/api/graphql/SAMkL5y_N9pmahSw8yy6gw/UserByScreenName'
  # The AUTHORIZATION_TOKEN value is a fixed value that is copy-pasted from the website
  AUTHORIZATION_TOKEN = 'AAAAAAAAAAAAAAAAAAAAANRILgAAAAAAnNwIzUejRCOuH5E6I8xnZz4puTs%3D1Zv7ttfk8LF81IUq16cHjhLTvJu4FA33AGWWjCpTnA'
  FEATURES = '{"creator_subscriptions_tweet_preview_api_enabled":true,"c9s_tweet_anatomy_moderator_badge_enabled":true,"tweetypie_unmention_optimization_enabled":true,"responsive_web_edit_tweet_api_enabled":true,"graphql_is_translatable_rweb_tweet_is_translatable_enabled":true,"view_counts_everywhere_api_enabled":true,"longform_notetweets_consumption_enabled":true,"responsive_web_twitter_article_tweet_consumption_enabled":false,"tweet_awards_web_tipping_enabled":false,"responsive_web_home_pinned_timelines_enabled":true,"freedom_of_speech_not_reach_fetch_enabled":true,"standardized_nudges_misinfo":true,"tweet_with_visibility_results_prefer_gql_limited_actions_policy_enabled":true,"longform_notetweets_rich_text_read_enabled":true,"longform_notetweets_inline_media_enabled":true,"responsive_web_graphql_exclude_directive_enabled":true,"verified_phone_label_enabled":false,"responsive_web_media_download_video_enabled":false,"responsive_web_graphql_skip_user_profile_image_extensions_enabled":false,"responsive_web_graphql_timeline_navigation_enabled":true,"responsive_web_enhance_cards_enabled":false}'
  USER_AGENT = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0'
  TWITTER_INIT_URL = 'https://x.com/?mx=2'
  HEADERS = {
    'authority': 'twitter.com',
    'accept': '*/*',
    'accept-language': 'en-US,en;q=0.9',
    'authorization': "Bearer #{AUTHORIZATION_TOKEN}",
    'content-type': 'application/json',
    'sec-ch-ua': '"Google Chrome";v="111", "Not(A:Brand";v="8", "Chromium";v="111"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'same-origin',
    'user-agent': USER_AGENT,
    # 'x-guest-token': None,
    'x-twitter-active-user': 'yes',  # yes
    'x-twitter-client-language': 'en',
  }

  def initialize(url)
    @url = url

    @data = {
      title: '',
      text: '',
      comment: '',
    }
  end

  def run
    if @url.match? TWITTER_URL_RE
      import_twitter(@url)
    else
      @data[:url] = @url
      import_standard(@url)
    end

    guess_tags

    Rails.logger.info("Find or create link with url=#{@data[:url]}")
    link = Link.find_or_create_by(url: @data[:url])
    link.update(@data)
  end

  def import_twitter(url)

    # We do initiate requests Session, and we get the `guest-token` from the HomePage
    client = HTTPClient.new(nil, USER_AGENT)
    resp = client.get(TWITTER_INIT_URL)
    match = resp.dump.match /gt=(\d+)/
    guest_token = match[1]
    HEADERS['x-guest-token'] = guest_token

    tweet_id = url.split('/')[5]
    arg = {
      "tweetId": tweet_id,
      "withCommunity":false,
      "includePromotedContent":false,
      "withVoice":false
    }
    params = {
      'variables': JSON.unparse(arg),
      'features': FEATURES,
    }

    response = client.get(
      GET_TWEET_URL,
      params,
      HEADERS
    )

    json = JSON.parse(response.body)

    result = json.dig("data", "tweetResult", "result") || {}
    legacy = result.dig("legacy") || {}
    #username = legacy.get("core", {}).get("user_results", {}).get("result", {}).get("legacy", {}).get("screen_name", "")
    urls_raw = legacy.dig("entities", "urls") || []
    urls = urls_raw.map {|u| u.dig("expanded_url") || "" }

    full_text = legacy.dig("full_text") || ""
    timestamp = legacy.dig("created_at") || ""

    @data[:source_url] = url
    @data[:published_at] = timestamp
    @data[:comment] = full_text
    @data[:url] = urls ? urls[0] : ''

    import_standard(@data[:url])
  end

  def import_standard(url)
    doc = Nokogiri::HTML(HTTPClient.get_content(url))
    @data[:title] = doc.css('head title').first.content

    doc.css('h1, h2, h3, h4, p, blockquote').each do |e|
      @data[:text] += e.text + "\n"
    end
  end

  def guess_tags()
    tag_ids = []
    Tag.where(category: 'topic').each do |tag|
      tag_re = tag.name.gsub('_', '.')
      if @data[:title].match? /\b#{tag_re}\b/i
        tag_ids << tag.id
      end
      if @data[:text].match? /\b#{tag_re}\b/i
        tag_ids << tag.id
      end
      if @data[:comment].match? /\b#{tag_re}\b/i
        tag_ids << tag.id
      end
      @data[:tag_ids] = tag_ids.uniq
    end
  end
end
