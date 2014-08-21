class Hq::BsStudentsController < Hq::StudentsController
  before_filter do
    @bs = Bs.find(params[:bs_id])
  end

  private

    def subject
      @bs
    end
end
