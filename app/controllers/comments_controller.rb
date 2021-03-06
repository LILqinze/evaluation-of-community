class CommentsController < ApplicationController
    before_action :logged_in_user, only: [:new, :create,:destroy]
    before_action :auth_check, only: [:destroy]
    def index
        @comments = Comment.paginate(page:params[:page],per_page:10)
    end
    def new
        @comment=Comment.new
        @curcourse=Course.find(params[:course_id])
    end
    def create
        #debugger
        @curcourse=Course.find(params[:course_id])
        @comment=Comment.new(content:comment_params[:content],user_id:current_user.id,course_id:@curcourse.id)
        
        if @comment.save
            redirect_to @curcourse
        else
            render 'new'
        end
    end
    def destroy
        comment=Comment.find(params[:id])
        course=comment.course
        comment.destroy
        flash[:success] = "评论已删除"
        page=params[:page].to_i
        if page==1
            redirect_to user_path(current_user,:opt=>1)
        elsif page==2
            redirect_to course   
        else
            redirect_to comments_path
        end
    end
    private
    def comment_params
        params.require(:comment).permit(:content)
    end
    def auth_check
        redirect_to(root_url) unless current_user && (current_user.admin || comment.user_id==current_user.id)
    end
end
