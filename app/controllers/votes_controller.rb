class VotesController < ApplicationController

  def create
    @voteable = find_votable
    @vote = @voteable.votes.new(vote_params.merge({user_id: current_user.id}))

    if @vote.save
      redirect_to :back
    else
      flash[:errors] = @vote.errors.full_messages
      redirect_to :back
    end
  end

  private
  def vote_params
    params.require(:vote).permit(:value)
  end

  def find_votable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
