class RoomsController < ApplicationController
  protect_from_forgery except: [:upload_photos]
  before_action :set_room, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]

  def index
    @rooms = current_user.rooms
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      flash[:notice] = "Saved."
      redirect_to listing_room_path(@room)
    else
      flash[:alert] = "Something went wrong."
      redirect_to request.referrer
    end
  end

  def show
    @guest_reviews = @room.guest_reviews
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
  end

  def amenities
  end

  def location
  end

  def update
    new_params = room_params
    new_params = room_params.merge(active: true) if is_ready_room

    if @room.update(new_params)
      flash[:notice] = "Saved."
    else
      flash[:alert] = "Something went wrong."
    end
    redirect_to request.referrer
  end

  def preload
    today = Date.today
    reservations = @room.reservations.where("(start_date >= ? or end_date >= ?) AND status = ?", today, today, 1)
    render json: reservations
  end

  def upload_photos
    @room.images.attach(params[:file])
    render json: {success: true}
  end

  def delete_photo
    @image = ActiveStorage::Attachment.find(params[:photo_id])
    @image.purge
    redirect_to photo_upload_room_path(@room.id)
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date, @room)
    }

    render json: output
  end

  private 

    def is_conflict(start_date, end_date, room)
      check = room.reservations.where("(? < start_date AND end_date < ?) AND  status = ?", start_date, end_date, 1)
      check.size > 0? true : false
    end

    def set_room
      @room = Room.find(params[:id])
    end

    def is_ready_room
      !@room.active && !@room.price.blank? && !@room.listing_name.blank? && !@room.images.blank? && !@room.address.blank?
    end

    def room_params
      params.require(:room).permit(:home_type,:room_type,:accommodate,:bed_room,:bath_room,:listing_name,:summary,:address,:is_tv,:is_kitchen,:is_air,:is_heating,:is_internet,:price,:active,:instant,images:[])
    end

end