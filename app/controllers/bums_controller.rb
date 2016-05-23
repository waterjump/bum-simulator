class BumsController < ApplicationController

  before_filter :bum_session, except: [:new, :show, :create]

  def new
    reset_session
  end

  def show
    Rails.logger.info "69BOT - show"
    Rails.logger.info "69BOT - session: #{session.inspect}"
    if current_user.present?
      Rails.logger.info "69BOT - user present"
      @bum = Bum.find_or_initialize(current_user.id)
    elsif session[:bum_id].present?
      Rails.logger.info "69BOT - session present"
      @bum = Bum.find(session[:bum_id])
    else
      redirect_to new_bum_path
    end

  end

  def create
    Rails.logger.info "69BOT - create"
    @bum = Bum.create!
    Rails.logger.info "69BOT - @bum.inspect: #{@bum.inspect}"
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

  def drink_beer
    @bum.drink_beer
    render :show
  end

  def rummage
  end

  def eat
    @bum.eat(params['food_id'])
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
