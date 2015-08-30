class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
         
  has_and_belongs_to_many :parents
  
  has_one :student_current_record, dependent: :destroy
  has_one :student_review_record, dependent: :destroy
  
  has_many :student_learnt_words, dependent: :destroy
  has_many :student_learnt_components, dependent: :destroy
end
