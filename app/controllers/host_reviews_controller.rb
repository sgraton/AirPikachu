class HostReviewsController < ApplicationController
    
    def create
        @reservation = Reservation.where(
                        id: host_review_params[:reservation_id], 
                        room_id: host_review_params[:room_id], 
                        user_id: host_review_params[:guest_id]
                    ).first

        if !@reservation.nil? 
            @has_reviewed = HostReview.where(
                                reservation_id: @reservation.id,
                                guest_id: host_review_params[:guest_id]
                            ).first

            if @has_reviewed.nil?
                # Allow to review
                @host_review = current_user.host_reviews.create(host_review_params)
                flash[:notice] = "Review created."
            else
                # Already reviewed
                flash[:alert] = "You already reviewed this reservation."
            end
        else
            flash[:alert] = "Not found this reservation."
        end

        redirect_to request.referrer
    end

    def destroy
        @host_review = Review.find(params[:id])
        @host_review.destroy

        flash[:notice] = "Removed."
        redirect_to request.referrer
    end

    private
        def host_review_params
            params.require(:host_review).permit(:star, :comment, :room_id, :reservation_id, :guest_id)
        end
end