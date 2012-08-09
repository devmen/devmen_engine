class Reviews::EntriesController < ApplicationController
  def index
    @reviews = Review::Entry.visible
  end

  def new
    @review = Review::Entry.new
  end

  def create
    @review = Review::Entry.new params[:review_entry]
    if @review.save
      redirect_to reviews_path, notice: I18n.t(:review_was_sent)
    else
      render :new
    end
  end
end
