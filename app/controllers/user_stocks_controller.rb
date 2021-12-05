class UserStocksController < ApplicationController

    def create
        
        stock=Stock.check_db(params[:ticker])
       
        if !stock
            stock=Stock.new_lookup(params[:ticker])  

            if !stock
                flash[:notice]="Stock not found! Please try again" 
                redirect_to my_portfolio_path
            end

            stock.save

        end

        UserStock.create(:user=>current_user,:stock=>stock)
        flash[:notice]="#{stock.name} has been added to your tracker" 
        redirect_to my_portfolio_path
    
    end

    def destroy

        stock=Stock.find(params[:id])
        if !stock
            flash[:notice]="Could not find the stock in your tracker.Try some other one...." 
            redirect_to my_portfolio_path
        end

        user_stock=UserStock.where(:user_id => current_user.id,:stock_id => params[:id]).first
        
        if user_stock
            user_stock.destroy
            flash[:notice]="#{stock.name} has been removed from your tracker" 
            redirect_to my_portfolio_path
        else
            flash[:alert]="Some error occured ! Please try again..." 
            redirect_to my_portfolio_path
        end
    end
end
