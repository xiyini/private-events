class EventAttendingsController < ApplicationController
  before_action :set_event_attending, only: %i[show edit update destroy]

  # GET /event_attendings or /event_attendings.json
  def index
    @event_attendings = EventAttending.all
  end

  # GET /event_attendings/1 or /event_attendings/1.json
  def show; end

  # GET /event_attendings/new
  def new
    @event_attending = EventAttending.new
  end

  # GET /event_attendings/1/edit
  def edit; end

  # POST /event_attendings or /event_attendings.json
  def create
    @event_attending = EventAttending.new(event_attending_params)
    @event = Event.find(@event_attending.attended_event_id)

    respond_to do |format|
      if @event.attendee_ids.include?(@event_attending.attendee.id)
        format.html do
          redirect_to @event, alert: 'Already Attend' end
      elsif @event.creator.id == @event_attending.attendee_id
        format.html do
          redirect_to @event, alert: 'You are the creator of this event' end
      elsif @event.private? && current_user != @event.creator
        format.html do
        redirect_to root_path, alert: 'This is a private event, you must have an invitation to join' end
      elsif @event_attending.save
        format.html do
 redirect_to event_url(@event), notice: 'Event attending was successfully created.' end
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event_attending.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_attendings/1 or /event_attendings/1.json
  def update
    respond_to do |format|
      if @event_attending.update(event_attending_params)
        format.html do
 redirect_to event_attending_url(@event_attending), notice: 'Event attending was successfully updated.' end
        format.json { render :show, status: :ok, location: @event_attending }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event_attending.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_attendings/1 or /event_attendings/1.json
  def destroy
    @event_attending.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Event attending was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event_attending
    @event_attending = EventAttending.find(params[:id])
  end

  def set_event
    @event = Event.find(@event_attending.attended_event_id)
  end

  # Only allow a list of trusted parameters through.
  def event_attending_params
    params.require(:event_attending).permit(:attendee_id, :attended_event_id)
  end
end
