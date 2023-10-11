# app/controllers/youtube_search_controller.rb

require 'net/http'
require 'json'
require 'uri'

class YoutubeSearchController < ApplicationController
  API_KEY = 'AIzaSyCNlX5CgDWFH4J-giBWIvWs1RjKa8j7klw'
  BASE_URL = 'https://www.googleapis.com/youtube/v3/search'

  def search
    query = params[:query]
    results = search_youtube(query)

    render json: results
  end

  private

  def search_youtube(query)
    uri = URI(BASE_URL)
    params = {
      key: API_KEY,
      q: query,
      part: 'snippet',
      type: 'video',
      maxResults: 10
    }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get(uri)
    json_response = JSON.parse(response)

    if json_response['items'] && !json_response['items'].empty?
      json_response['items'].map do |item|
        {
          title: item['snippet']['title'],
          url: "https://www.youtube.com/watch?v=#{item['id']['videoId']}"
        }
      end
    else
      []
    end
  end
end
