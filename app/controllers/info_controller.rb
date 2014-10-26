class InfoController < ApplicationController
  def registrations
  	if user_signed_in?
  		redirect_to movies_url, status: 307
  	end
  end
end
