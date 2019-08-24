class ReservationMailer < ApplicationMailer
    def send_email_to_guest(guest, room)
        @recipient = guest
        @room = room
        mail(to: @recipient.email, subject: "Enjoy your trip ! 😘")
    end
end