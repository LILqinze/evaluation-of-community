class CoursesController < ApplicationController
    before_action :auth_check, only: [:destroy]
    def index
        @courses = Course.paginate(page:params[:page],per_page:10)
    end
    def show
        @course=Course.find(params[:id])
        @ccomments = @course.comments.paginate(page:params[:page],per_page:10)
        @curpage=2;
    end
    def upload
        uploaded_io = params[:course_csv]
        Course.readCSV(uploaded_io)
        redirect_to courses_path
    end
    def destroy
        course=Course.find(params[:id])
        course.destroy
        flash[:success] = "课程已删除"
        redirect_to courses_path
    end
    private
    def auth_check
        redirect_to(courses_path) unless current_user && current_user.admin?
    end
end
