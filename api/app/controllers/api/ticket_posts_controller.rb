class Api::TicketPostsController < ApplicationController
  before_action :authenticate_user!

  def index
    posts = TicketPost.includes(:user).order(created_at: :desc)
    render json: posts.map { |p|
      {
        id: p.id,
        event_title: p.event.title,
        post_type: p.post_type,
        contact_info: p.contact_info,
        username: p.user.username
      }
    }
  end

  def create
    post = current_user.ticket_posts.new(ticket_post_params)
    if post.save
      render json: { message: "Post created" }, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def ticket_post_params
    params.require(:ticket_post).permit(:post_type, :event_id, :contact_info, :price, :looking_for, :note)
  end
end
