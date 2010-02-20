class Admin::CurrenciesController < Admin::AdminController
  
  def index
    @currencies = Currency.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @currency = Currency.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @currency = Currency.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /currencies/1/edit
  def edit
    @currency = Currency.find(params[:id])
  end

  # POST /currencies
  # POST /currencies.xml
  def create
    @currency = Currency.new(params[:currency])

    respond_to do |format|
      if @currency.save
        flash[:notice] = 'Currency was successfully created.'
        format.html { redirect_to(admin_currency_url(@currency)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /currencies/1
  # PUT /currencies/1.xml
  def update
    @currency = Currency.find(params[:id])

    respond_to do |format|
      if @currency.update_attributes(params[:currency])
        flash[:notice] = 'Currency was successfully updated.'
        format.html { redirect_to(admin_currency_url(@currency)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.xml
  def destroy
    @currency = Currency.find(params[:id])
    @currency.destroy

    respond_to do |format|
      format.html { redirect_to(admin_currencies_url) }
    end
  end
end
