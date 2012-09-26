class HomeController < ApplicationController
  before_filter :signed_in?
	
  def index
    if signed_in?
      @post = Post.new()
      @post.post_type = 'question'

      case params[:post_filter]
      when 'questions'
        cookies[:post_filter] = 'question'
        @post_filter = {post_type: cookies[:post_filter]}
      
      when 'infos'
        cookies[:post_filter] = 'info'
        @post_filter = {post_type: cookies[:post_filter]}
      
      when 'all'
        cookies[:post_filter] = 'all'
        @post_filter = {post_type: ["info", "question"]}
      
      else 
        case cookies[:post_filter]
        when 'info'
          @post_filter = {post_type: 'info'}
        when 'question'
          @post_filter = {post_type: 'question'}
        else 
          @post_filter = {post_type: ["info", "question"]}
        end
      end

      if params[:course_filter].eql? 'subscribed'

        cookies[:course_filter] = 'subscribed'
        @posts = Post.order('last_activity DESC, updated_at DESC, created_at DESC').where(@post_filter).keep_if{|post| !current_user.course_membership(post.course).nil?}
        @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(20)
      elsif params[:course_filter].eql? 'all'
        cookies[:course_filter] = 'all'
        @posts = Post.order('last_activity DESC, updated_at DESC, created_at DESC').where(@post_filter).page(params[:page]).per(20)
      else
        case cookies[:course_filter]
        when 'subscribed'
          @posts = Post.order('last_activity DESC, updated_at DESC, created_at DESC').where(@post_filter).keep_if{|post| !current_user.course_membership(post.course).nil?}
          @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(20)
        else 
          @posts = Post.order('last_activity DESC, updated_at DESC, created_at DESC').where(@post_filter).page(params[:page]).per(20)
        end
      end
    else
      redirect_to root_path
    end
  end
end
