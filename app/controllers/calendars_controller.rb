class CalendarsController < ApplicationController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]

  # GET /calendars
  # GET /calendars.json
  def index
    @calendars = Calendar.all  
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show  

  end

  # GET /calendars/new
  def new
    @calendar = Calendar.new
  end

  # GET /calendars/1/edit
  def edit
  end

  def generate_carwash

    collaborators = User.order('name').map(&:id)
    carwash_available_spots = 5
    current_date = Date.today

    last_spot = Calendar.last

    if last_spot != nil
      current_date = last_spot.date
      count = Calendar.where(date:current_date).count
      missing_spots = carwash_available_spots - count
      puts "#{missing_spots.inspect}"
      #fill missing spots
      if missing_spots>1
        missing_spots.times do

          collaborator = collaborators.shift
          
          if(collaborator!=nil)
            carwash = Calendar.new
            carwash.user_id = collaborator
            carwash.date = current_date
            carwash.save        
            puts "#{collaborator.inspect+" "+current_date.inspect}"
          end

        end
      end
      current_date += 1  
    end

    while(collaborators.count > 0) do

     weekdays=current_date.weekday?
     if weekdays==false
        current_date += 2
      end
     carwash_available_spots.times do
      
      collaborator = collaborators.shift

      if(collaborator!=nil)
        carwash = Calendar.new
        carwash.user_id = collaborator
        carwash.date = current_date
        carwash.save  
       end

    end
      current_date += 1       

  end



  redirect_to :controller => 'calendars', :action => 'index'
end




def create
  @calendar = Calendar.new(calendar_params)

  respond_to do |format|
    if @calendar.save
      format.html { redirect_to @calendar, notice: 'The Carwash schedule was successfully created.' }
      format.json { render :show, status: :created, location: @calendar }
    else
      format.html { render :new }
      format.json { render json: @calendar.errors, status: :unprocessable_entity }
    end
  end

end


def update
  respond_to do |format|
    if @calendar.update(calendar_params)
      format.html { redirect_to @calendar, notice: 'Calendar was successfully updated.' }
      format.json { render :show, status: :ok, location: @calendar }
    else
      format.html { render :edit }
      format.json { render json: @calendar.errors, status: :unprocessable_entity }
    end
  end
end

def destroy
  @calendar.destroy
  respond_to do |format|
    format.html { redirect_to calendars_url, notice: 'Calendar was successfully destroyed.' }
    format.json { head :no_content }
  end
end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_params
      params.require(:calendar).permit(:date, :user_id)
    end

  end
