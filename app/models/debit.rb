class Debit < Transaction
  def self.create(params)
    params[:amount] = params[:amount] * -1
    self.create!(params)
  end
end
