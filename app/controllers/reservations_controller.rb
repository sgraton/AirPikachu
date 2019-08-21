class ReservationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_reservation, only: [:approve, :decline]

    def create
        room = Room.find(params[:room_id])

        if room.user == current_user
            flash[:alert] = "You cannot book your own property !"
        else
            start_date = Date.parse(reservations_params[:start_date])
            end_date = Date.parse(reservations_params[:end_date])
            days = (end_date - start_date).to_i + 1

            @reservation = current_user.reservations.build(reservations_params)
            @reservation.room = room
            @reservation.price = room.price
            @reservation.total = room.price * days

            if @reservation.save
                if room.Request?
                    flash[:notice] = "Request sent successfully !"
                else
                    @reservation.Approved!
                    flash[:notice] = "Reservation created successfully !"
                end
            else
                flash[:alert] = "Cannot make a reservation !"
            end
        end

        redirect_to room
    end

    def your_trips
        @trips = current_user.reservations.order(:start_date, :asc)
    end

    def your_reservations
        @rooms = current_user.rooms
    end

    def approve
        @reservation.Approved!
        redirect_to your_reservations_path
    end

    def decline
        @reservation.Declined!
        redirect_to your_reservations_path
    end

    private
        def reservations_params
            params.require(:reservation).permit(:start_date, :end_date)
        end

        def set_reservation
            @reservation = Reservation.find(params[:id])
        end
end