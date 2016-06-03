class BumsController < ApplicationController

  before_filter :bum_session, except: [:new, :show, :create]

  def new
    reset_session
  end

  def show
    if current_user.present?
      bum = Bum.find_or_initialize(current_user.id)
      @bum = BumViewModel.wrap(bum)
    elsif session[:bum_id].present?
      bum = Bum.find(session[:bum_id])
      @bum = BumViewModel.wrap(bum)
    else
      redirect_to new_bum_path
    end
  end

  def create
    @bum = BumViewModel.wrap(Bum.create!)
    session[:bum_id] = @bum.id
    redirect_to bum_path
  end

  # Game actions

  def panhandle
    Bum::Action::Panhandle.new(@bum).perform
    render :show
  end

  def sleep
    Bum::Action::Sleep.new(@bum, hours: params['hours'].to_i).perform
    render :show
  end

  def rummage
    Bum::Action::Rummage.new(@bum).perform
    render :show
  end

  def consume
    Bum::Action::Consume.new(@bum, grocery_id: params['grocery_id']).perform
    render :show
  end

  protected

  def bum_session
    if session[:bum_id].present?
      @bum = BumViewModel.wrap(Bum.find(session[:bum_id]))
    else
      @bum = BumViewModel.wrap(Bum.create!)
      session[:bum_id] = @bum.id
    end
  end
end
