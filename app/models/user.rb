class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :trees, dependent: :destroy
  has_many :con_files, dependent: :destroy
  has_many :con_links, dependent: :destroy
  has_many :con_taxons, dependent: :destroy
  has_many :selection_taxons, dependent: :destroy
  has_many :subset_taxons, dependent: :destroy
end
