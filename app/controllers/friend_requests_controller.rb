class FriendRequestsController < ApplicationController
	include SessionsHelper

	before_action :set_friend_request, except: [:index, :create]

	def create

		friend = User.find(params[:friend_id])

		@friend_request = current_user.friend_requests.new(friend: friend)

		if @friend_request.save
			post_attributes
			render "posts/index", status: :created, location: @friend_request
		else
			render json: @friend_request.errors, status: unprocessable_entity
		end
	end

	def update
		post_attributes
		@friend_request.accept
		redirect_to posts_path
	end

	def destroy
		post_attributes
		@friend_request.destroy
		redirect_to posts_path
	end


	private

	def set_friend_request
		@friend_request = FriendRequest.find(params[:id])
	end

	def post_attributes
		@posts = Post.all
		@user = User.find(session[:id])
	end
end