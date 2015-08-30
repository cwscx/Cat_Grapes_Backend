class Initialization < ActiveRecord::Migration
  def change
    create_table(:students) do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## User defined
      t.string  :name,              null: false, default: ""
      t.integer :grade,             null: false
      
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :students, :email,                unique: true
    add_index :students, :reset_password_token, unique: true
    add_index :students, :confirmation_token,   unique: true
    # add_index :students, :unlock_token,         unique: true
       
    
    # Record to check Student's current schedule
    # Belongs to 'Student'
    create_table :student_current_records do |t|
      t.belongs_to :student, index: true
      t.integer :book_id, null: false
      t.integer :unit_id, null: false
      t.integer :case_id, null: false
      t.integer :video_id
      t.integer :exercise_id

      t.timestamps null: false
    end
 
 
    # Record to check Student's review records
    # Belongs to 'Student'
    create_table :student_review_records do |t|
      t.belongs_to :student, index: true
      t.integer :streak, null: false
      t.date :next_test_date, null: false
      t.text :review_history, null: false
      t.integer :coins, null: false
      t.time :review_time, null: false

      t.timestamps null: false
    end
 
 
    # Record to check Student's learnt words
    # Belongs to 'Studnet'   
    create_table :student_learnt_words do |t|
      t.belongs_to :student, index: true
      t.float :current_strength, null: false
      t.text :strength_history, null: false
      t.date :next_test_date
      t.integer :test_interval, null: false
      t.text :test_date_array, null: false
      t.integer :word_id, null: false

      t.timestamps null: false
    end
    
    
    # Record to check Student's learnt components
    # Belongs to 'Studnet'   
    create_table :student_learnt_components do |t|
      t.belongs_to :student, index: true
      t.float :current_strength, null: false
      t.text :strength_history, null: false
      t.date :next_test_date
      t.integer :test_interval, null: false
      t.text :test_date_array, null: false
      t.integer :component_id, null: false

      t.timestamps null: false
    end
    
    
    # The outter most model 'Book'
    # Global
    # Has many 'Unit's
    create_table :books do |t|
      t.string :title, null: false

      t.timestamps null: false
    end
    add_index :books, :title, unique: true
    
    
    # Belongs to 'Book'
    # Global
    # Has many 'Case's
    create_table :units do |t|
      t.belongs_to :book, index: true
      t.string :subtitle, null: false
      t.integer :sequence_id, null: false

      t.timestamps null: false
    end
    add_index :units, :subtitle, unique: true


    # Belongs to 'Unit'
    # Global
    # Has many 'Video's and 'Exercise's
    create_table :cases do |t|
      t.belongs_to  :unit, index:true
      t.integer :sequence_id, null: false

      t.timestamps null: false
    end
    
    
    # Belongs to 'Case'
    # Global
    create_table :videos do |t|
      t.belongs_to :case, index: true
      t.string :youku_id, null: false
      t.integer :sequence_id, null: false

      t.timestamps null: false
    end
    add_index :videos, :youku_id, unique: true


    # Belongs to 'Case'
    # Global
    # Has many 'Component's and 'Word's
    create_table :exercises do |t|
      t.belongs_to :case, index: true
      t.integer :sequence_id, null: false
      
      t.timestamps null: false
    end
    
    
    # Has many 'Exercise's and 'Sentence's
    # Global
    create_table :components do |t|
      t.string :name, null: false
      t.string :family
      t.boolean :reduciable, null: false

      t.timestamps null: false
    end


    # Has many 'Exercise's and 'Sentence's
    # Global
    create_table :words do |t|
      t.string :chinese, null: false
      t.string :english, null: false
      t.string :partofspeech, null: false
      t.string :family
      t.string :disctractors
      t.string :source_title, null: false
      t.integer :grade, null: false
      t.integer :semester, null: false

      t.timestamps null: false
    end
    
    
    # The outter most model 'Sentence'
    # Global
    # Has 'Component's and 'Word's
    create_table :sentences do |t|
      t.text :chinese, null: false
      t.text :english, null: false
      t.text :distractors
      t.text :equivalents
      t.integer :core_id, null: false
      t.string :structure, null: false
      t.string :source_title, null: false
      t.integer :grade, null: false
      t.integer :semester, null: false

      t.timestamps null: false
    end
    
    
    # Build has_and_belongs_to_many relationship between exercises and words
    create_table :exercises_words do |t|
      t.belongs_to :exercise, index: true
      t.belongs_to :word, index: true
    end

    # Build has_and_belongs_to_many relationship between exercises and components
    create_table :components_exercises do |t|
      t.belongs_to :exercise, index: true
      t.belongs_to :component, index: true
    end
    
    # Build has_and_belongs_to_many relationship between sentences and components
    create_table :components_sentences do |t|
      t.belongs_to :sentence, index: true
      t.belongs_to :component, index: true
    end

    # Build has_and_belongs_to_many relationship between sentences and words    
    create_table :sentences_words do |t|
      t.belongs_to :sentence, index: true
      t.belongs_to :word, index: true
    end
  end
end
