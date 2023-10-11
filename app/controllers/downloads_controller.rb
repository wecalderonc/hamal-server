class DownloadsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    video_url = params[:url]
    video_title = params[:title]
    YoutubeDownloaderService.download_mp3(video_url, video_title)
    send_file "tmp/#{video_title}.mp3", type: 'audio/mpeg', disposition: 'attachment'
  end
end
