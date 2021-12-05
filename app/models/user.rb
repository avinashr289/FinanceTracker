class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_stocks
  has_many :stocks,:through => :user_stocks
  
  has_many :friendships
  has_many :friends,:through => :friendships




  def can_track_stock?(ticker)
    user_stock_count < 10 && !stock_already_tracking?(ticker)
  end

  def user_stock_count
      stocks.count
  end

  def stock_already_tracking?(ticker)

    stock=Stock.check_db(ticker)
    
    return false if !stock

    stocks.where(:id=>stock.id).exists?

  end

  def full_name

    return "#{first_name} #{last_name}"  if first_name || last_name 

    "Anonymous"

  end

  def self.matches(field_name,param)
    where("#{field_name} like ?","%#{param}%")
  end

  def self.search(param)
    param.strip!
    to_send_back=(first_name_matches(param)+last_name_matches(param)+email_matches(param)).uniq
    return nil if !to_send_back

    to_send_back

  end

  def self.first_name_matches(param)
    matches("first_name",param)
  end

  def self.last_name_matches(param)
    matches("last_name",param)
  end

  def self.email_matches(param)
    matches("email",param)
  end

  def except_current_user(users)
    users.reject{ |user| user.id == self.id }
  end

end
