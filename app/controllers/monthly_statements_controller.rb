class MonthlyStatementsController < ApplicationController
  layout 'with_sidebar'

  before_filter :prepare_monthly_statement, :only => [:bill, :payment]

  def index
    @year = (params[:year] && params[:year].to_i) || Date.today.year
    @monthly_statements = subject.monthly_statements.of_year(@year)
    @monthly_statement_strips = @monthly_statements.each_with_object({}) do |statement, obj|
      obj[statement.month] = statement
    end
  end

  def show
    @monthly_statement = subject.monthly_statements.find(params[:id])
    respond_to do |format|
      format.html
      format.json{ render json: @monthly_statement }
    end
  end

  def create
    @monthly_statement = MonthlyStatement.new(owner:subject, year:params[:year], month:params[:month])
    if @monthly_statement.save
      redirect_to action:"show", id:@monthly_statement
    else
      render action:"index"
    end
  end

  # POST monthly_statements/:id
  def calculate
    @monthly_statement = subject.monthly_statements.find(params[:id])
    @monthly_statement.calculate
    redirect_to action: :show
  end

  # POST monthly_statements/:id/calculate_all
  def calculate_all
    @monthly_statement = subject.monthly_statements.find(params[:id])
    MonthlyStatement.calculate_for_all(@monthly_statement.year, @monthly_statement.month)
    redirect_to({action:"show"}, notice:t("messages.calculation_finished"))
  rescue => e
    logger.error e
    logger.error e.backtrace.join("\t")
    redirect_to({action:"show"}, alert:e.message)
  end

  def bill
    @demandee = demandee
    render layout: 'plain'
  end

  def payment
    @demandee = demandee
    render layout: 'plain'
  end

  private

    def prepare_monthly_statement
      @monthly_statement = subject.monthly_statements.find(params[:id])
    end

    def subject
      current_user
    end

    def demandee
      subject
    end
end
