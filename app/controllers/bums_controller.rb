class BumsController < ApplicationController

  before_filter :bum_session, except: [:new, :show, :create]

  def new
    reset_session
  end

  def show
    if current_user.present?
      @bum = Bum.find_or_initialize(current_user.id)
    elsif session[:bum_id].present?
      @bum = Bum.find(session[:bum_id])
    else
      redirect_to new_bum_path
    end
  end

  def create
    @bum = Bum.create!
    session[:bum_id] = @bum.id
    redirect_to bum_path
  end

  # Game actions

  def panhandle
    @bum.panhandle
    render :show
  end

  def sleep
    @bum.sleep(params['hours'].to_i)
    render :show
  end

  def rummage
    @bum.rummage
    render :show
  end

  def consume
    @bum.consume(params['grocery_id'])
    render :show
  end

  protected

  def bum_session
    if session[:bum_id].present?
      @bum = Bum.find(session[:bum_id])
    else
      @bum = Bum.create!
      session[:bum_id] = @bum.id
    end
  end
end
