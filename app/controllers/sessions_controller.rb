class SessionsController < ApplicationController
  layout 'sessions'
  skip_before_filter :login_required, :only => [:new, :create]

  def new
  end

  def create
    if user = User.authenticate( params[:user][:uid], params[:user][:password] ) # REST/OAuth?
      flash[:notice] = t('flash.session.login_successful')
      session[:dn] = user.dn
      session[:password_plaintext] = params[:user][:password]

      #redirect_back_or_default schools_url
      redirect_back_or_default root_path
    else
      flash[:notice] = t('flash.session.failed')
      render :action => :new
    end
  end

  def auth

    respond_to do |format|
      format.json { render :json => true.to_json }
    end
  end

  def show
    @user = User.find(session[:dn])
    respond_to do |format|
      format.json  { render :json => @user.to_json(:methods => :managed_schools) }
    end
  end

  def destroy
    # Remove dn and plaintext password values from session
    session.delete :password_plaintext
    session.delete :dn
    flash[:notice] = t('flash.session.logout_successful')
    redirect_to login_path
  end
end
