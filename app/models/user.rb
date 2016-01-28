class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :trees, dependent: :destroy
  has_many :con_files, dependent: :destroy
  has_many :con_links, dependent: :destroy
end
