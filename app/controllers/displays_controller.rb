class DisplaysController < ApplicationController
  def index
  	@date= Calendar.where(:all, :conditions => ["date between ? AND ?", DateTime.now.beginning_of_month, DateTime.now.end_of_month]) 
  end
end
