class User < Client
  def self.model_name
    superclass.model_name
  end
end
