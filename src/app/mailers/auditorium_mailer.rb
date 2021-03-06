class AuditoriumMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  default from: "auditorium <notification@auditorium.inf.tu-dresden.de>",
          'message-id' => "<notification@auditorium.inf.tu-dresden.de>"


  def welcome_email(user)
  	@user = user
    @url = "http://auditorium.inf.tu-dresden.de"
    mail(to: @user.email, subject: 'Welcome to auditorium. Your account has been confirmed.')
  end 

  def membership_changed(course, user, membership_type)
  	@user = user
  	@url = course_url(course)
  	@course = course 

  	mail(to: @user.email, 
  		subject: "You are now a#{'n' if membership_type.eql? 'editor'} #{membership_type} of #{course.name_with_term}.", 
  		template_path: "auditorium_mailer",
  		template_name: "#{membership_type}_membership")
  end

  def private_question(user, post)
  	@user = user
  	@course = post.course
  	@url = course_url(post.course)
  	@post = post
  	membership = CourseMembership.find_by_course_id_and_user_id(@course.id, @user.id)
    @membership_type = membership.membership_type if !membership.nil?

    if @user.is_admin? and not (@membership_type.eql? 'maintainer' or @membership_type.eql? 'editor')
      @template = 'private_question_admin'
    else
      @template = 'private_question'
    end

  	mail(to: @user.email,
  		subject: "New private question in #{@post.course.name_with_term}",
  		template_path: 'auditorium_mailer',
  		template_name: @template,
      'message-id' => "<notification-#{@post.id}@auditorium.inf.tu-dresden.de>")
  end

  def update_in_course(user, post) 
    @user = user
    @course = post.course
    @url = course_url(post.course)
    @post = post
    
    private_flag = 'private ' if post.origin.is_private?

    case post.post_type

    when 'info'
      subject = "New #{private_flag}announcement in #{@post.course.name_with_term}"
      in_reply_to = nil
    when 'question'
      subject = "New #{private_flag}question in #{@post.course.name_with_term}" 
      in_reply_to = nil
    when 'comment'
      subject = "New #{private_flag}comment in #{@post.course.name_with_term}"
      in_reply_to = "<notification-#{@post.parent().id}@auditorium.inf.tu-dresden.de>" if @post.parent().presence
    when 'answer'
      subject = "New #{private_flag}answer in #{@post.course.name_with_term}"
      in_reply_to = "<notification-#{@post.parent().id}@auditorium.inf.tu-dresden.de>" if @post.parent().presence
    else
      subject = "New post in #{@course.name_with_term}."
      in_reply_to = nil
    end

    headers['in-reply-to'] = in_reply_to if in_reply_to.presence
    mail(to: @user.email,
      subject: subject,
      template_path: 'auditorium_mailer',
      template_name: 'update_in_course',
      'message-id' => "<notification-#{@post.id}@auditorium.inf.tu-dresden.de>")
  end

  def new_course_to_approve(course, admin)
    @user = admin
    @course_url = course_url(course)
    @course = course 

    mail(to: @user.email, 
      subject: "The course '#{course.name_with_term}' needs to be approved.")
  end

  def course_approved(course, user)
    @user = user
    @course_url = course_url(course)
    @course = course 

    mail(to: @user.email, 
      subject: "Your course '#{course.name_with_term}' has been approved.")
  end

  def user_becomes_admin(user)
    @user = user
    mail(to: @user.email, subject: 'You are now admin of auditorium!')
  end

  def confirm_membership_request(membership_request)
    @membership_request = membership_request
    @user = @membership_request.user
    @url = course_url(@membership_request.course)
    @course = @membership_request.course
    @confirmed = @membership_request.confirmed ? 'confirmed' : 'rejected' 

    mail(to: @membership_request.user.email, 
      subject: "Your #{@membership_request.membership_type} request in #{@membership_request.course.name_with_term} has been #{@confirmed}.", 
      template_path: "auditorium_mailer",
      template_name: "#{@membership_request.membership_type}_membership")
  end

  def reject_membership_request_add_as_member(membership_request)
    @membership_request = membership_request
    @user = @membership_request.user
    @url = course_url(@membership_request.course)
    @course = @membership_request.course

    mail(to: @membership_request.user.email, 
      subject: "You're now a member of #{@membership_request.course.name_with_term}.", 
      template_path: "auditorium_mailer",
      template_name: "member_membership")  
  end
end
