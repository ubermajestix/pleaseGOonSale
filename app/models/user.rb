require 'digest/sha1'
class User < ActiveRecord::Base
  
  attr_accessor :password
  
  validates_presence_of :name
  validates_uniqueness_of :email
  validates_format_of   :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  before_create :check_password
  # TODO rake task that deletes/locks users after x days of not confirming
  before_create :create_confirmation_code
  
  has_many :users_item
  has_many :items, :through => :users_item
  
  def self.authenticate(email, password)
    u = User.first( :conditions => {:email=>email})
    u && u.authenticated?(password) && u.has_confirmed ? u : nil
  end
  
  def self.confirmed?(email)
    u = User.first( :conditions => {:email=>email})
    u && u.has_confirmed
  end
  
  def self.confirm(code)
    u = first(:conditions=>{:confirmation_code => code})
    u ? (u.confirm!; return u) : nil
  end
  
  def confirm!
    update_attributes(:has_confirmed => true)
  end
  
  def authenticated?(password)
    BCrypt::Password.new(crypted_password) == password
  end
  
private

   def check_password
     unless password_valid?
       return false
     end
     if password_required?
       errors.add(:password, "can't be blank.")
       return false unless !password.blank?
     end
     encrypt_password
     true
   end
   
   def password_valid?
     if password.length < 6
       errors.add(:password, "has to be at least 6 characters long.")
       return false
     end
     unless password.match(/\d/) && password.match(/[a-zA-Z]/)
       errors.add(:password, "must have at least a number and digit.")
       return false
     end
     return true
   end

   def password_required?
     crypted_password.blank? || !password.blank?
   end


   def encrypt_password
     return if password.blank?
     self.crypted_password = BCrypt::Password.create(password)
   end
   
   def create_confirmation_code
     self.confirmation_code = Digest::SHA1.hexdigest(email+Time.now.to_s)
   end
  
end