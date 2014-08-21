class AddressesController < ApplicationController
  def search
    #params[:postal_code]
    @postal_code = PostalCode.search_by_postal_code(params[:postal_code])
    if @postal_code
      render json:@postal_code.as_json(:methods => :line1)
    else
      head :not_found
    end
  end
end
