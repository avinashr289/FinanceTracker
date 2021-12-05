class Stock < ApplicationRecord

    has_many :user_stocks
    has_many :users,:through => :user_stocks

    validates :name , :ticker , presence: true

    def self.new_lookup(ticker_symbol)

        client = IEX::Api::Client.new(
            publishable_token: Rails.application.credentials.iex[:public_key],
            secret_token: Rails.application.credentials.iex[:secret_key],
            endpoint: 'https://cloud.iexapis.com/v1'
          )
        
        begin
            details=client.quote(ticker_symbol)
            new(:ticker => ticker_symbol, :name => details.company_name ,:last_price => details.latest_price)    
        rescue=>e
            return nil
        end
        
    end


    def self.check_db(ticker)
        where(:ticker => ticker).first
    end
    
end
