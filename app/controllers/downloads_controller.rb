class DownloadsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    video_url = params[:url]
    YoutubeDownloaderService.download_mp3(video_url)
    # You can either send the file directly or save it and send a link.
    send_file 'tmp/downloaded_file.mp3', type: 'audio/mpeg', disposition: 'attachment'
  end
end
