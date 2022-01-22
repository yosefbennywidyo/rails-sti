class TransactionsController < ApplicationController
  before_action :set_client_transaction

  def index
    
  end

  def debit
    
  end

  def create_debit
    setup_debit_params(transaction_params)
    @transaction = Transaction.new(@params)

    if params[:debit][:amount].to_i < 0
      redirect_to client_transactions_path, notice: "#{@transaction.type} was failed, make sure you're using positive amount"
    else
      respond_to do |format|
        if @transaction.save
          format.html { redirect_to client_transactions_path, notice: "#{@transaction.type} was successfully created." }
          format.json { render :show, status: :created, location: @transaction }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @transaction.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def setup_debit_params(params)
    @params = {
      client_id: params[:client_id],
      amount: ("#{params[:debit][:amount]}".to_i.abs * -1),
      type: 'Debit',
      sender_wallet_id: Client.find_by_id(params[:client_id]).wallet.id,
      receiver_wallet_id: Client.find_by_email(params[:client][:email]).wallet.id
    }
  end

  def credit

  end

  def create_credit
    setup_credit_params(transaction_params)
    @transaction = Transaction.new(@params)

    if params[:credit][:amount].to_i < 0
      redirect_to client_transactions_path, notice: "#{@transaction.type} was failed, make sure you're using positive amount"
    else
      respond_to do |format|
        if @transaction.save
          format.html { redirect_to client_transactions_path, notice: "#{@transaction.type} was successfully created." }
          format.json { render :show, status: :created, location: @transaction }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @transaction.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def setup_credit_params(params)
    @params = {
      client_id: params[:client_id],
      amount: params[:credit][:amount],
      type: 'Credit',
      sender_wallet_id: nil,
      receiver_wallet_id: Client.find_by_id(params[:client_id]).wallet.id
    }
  end

  def new
    
  end

  def show
    puts "params.inspect: #{params.inspect}"
    puts "params[:type]: #{params[:type]}"
    @client = Client.find_by_id(params[:id])
    @user = Client.find_by_id(params[:id])
    @team = Client.find_by_id(params[:id])
    @stock = Client.find_by_id(params[:id])

    puts "@client.inspect: #{@client.inspect}"
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # POST /clients or /clients.json
  def create
    puts "transaction_params.inspect: #{transaction_params.inspect}"
    puts "params.inspect: #{params.inspect}"
    puts "transaction_params.permitted?: #{transaction_params.permitted?}"
    puts "params.permitted?: #{params.permitted?}"
    @client = Client.new(params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to client_url(@client), notice: "#{@client.type} was successfully created." }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client_transaction
      @client = Client.find_by_id(params[:client_id])
      @client_balance = @client.transactions.balance(@client.wallet)
      @client_debit   = @client.transactions.debit(@client.wallet)
      @client_credit  = @client.transactions.credit(@client.wallet)
    end

    # Only allow a list of trusted parameters through.

    def transaction_params
      params.permit(:client_id, debit: [:amount], credit: [:amount], client: [:email])
    end

end
