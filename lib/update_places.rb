module UpdatePlaces
  
  def self.included( base_class )
    base_class.class_eval do
      include UpdatePlaces::InstanceMethods
    end
  end
  
  
  module InstanceMethods
    # AJAX target for constraining provinces by country
    def update_provinces
      lists = {}
      unless params[:country_id].blank?
        conditions = { :country_id => params[:country_id] }
        lists[:provinces] = Province.find( :all,
          :include => nil,
          :conditions => conditions,
          :select => 'id, name'
        ).map { |province| [ province.name, province.id ] }
      end
      render :partial => 'update_provinces',
        :layout => false,
        :locals => { :lists => lists }
    end
    
    # AJAX target for constraining provinces by country
    def update_markets
      lists = {}
      unless params[:country_id].blank?
        conditions = { :country_id => params[:country_id] }
        lists[:markets] = Market.find( :all,
          :include => nil,
          :conditions => conditions,
          :select => 'id, name'
        ).map { |market| [ market.name, market.id ] }
      end
      render :partial => 'update_markets',
        :layout => false,
        :locals => { :lists => lists }
    end
    
    # AJAX target for constraining cantons by province
    def update_cantons
      lists = {}
      unless params[:province_id].blank?
        conditions = { :province_id => params[:province_id] }
        lists[:cantons] = Canton.find( :all,
          :include => nil,
          :conditions => conditions.merge(
            :province_id => params[:province_id]
          ),
          :select => 'id, name'
        ).map { |canton| [ canton.name, canton.id ] }
      end
      render :partial => 'update_cantons',
        :layout => false,
        :locals => { :lists => lists }
    end
  end
end
