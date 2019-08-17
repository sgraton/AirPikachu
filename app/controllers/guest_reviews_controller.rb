class GuestReviewsController < ApplicationController
    
    def create
        @reservation = Reservation.where(
                        id: guest_review_params[:reservation_id], 
                        room_id: guest_review_params[:room_id]
                    ).first

        if !@reservation.nil? && @reservation.room.user.id == guest_review_params[:host_id].to_i
            @has_reviewed = GuestReview.where(
                                reservation_id: @reservation.id,
                                host_id: guest_review_params[:host_id]
                            ).first

            if @has_reviewed.nil?
                # Allow to review
                @guest_review = current_user.guest_reviews.create(guest_review_params)
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
        @guest_review = Review.find(params[:id])
        @guest_review.destroy

        flash[:notice] = "Removed."
        redirect_to request.referrer
    end

    private
        def guest_review_params
            params.require(:guest_review).permit(:star, :comment, :room_id, :reservation_id, :host_id)
        end
end