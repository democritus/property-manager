class AgentsController < ApplicationController

  caches_page :snapshot

  # GET /agents/snapshot/1
  # GET /agents/snapshot/1.xml
  def snapshot
    @agent = Agent.find(:first,
      :include => { :user => :user_icons },
      :conditions => { :id => params[:id] }
    )

    respond_to do |format|
      format.html  { render :layout => nil }
      format.xml  { render :xml => @agent }
    end
  end
end
