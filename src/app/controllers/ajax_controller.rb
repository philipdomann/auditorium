class AjaxController < ApplicationController
  def courses
  	if params[:term]
      like= "%".concat(params[:term].concat("%"))
      courses = Course.where("name like ?", like).limit(10)
    else
      courses = Course.all(limit: 10)
    end
    list = courses.map {|c| Hash[ id: c.id, label: (c.name_with_term short: false), name: (c.name_with_term short: false)]}
    render json: list
  end
end