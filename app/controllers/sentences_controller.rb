class SentencesController < ApplicationController
  def index
    # Array to transform the words and components into arrays
    words_array = request.params[:learnedWords].split(/\s*,\s*/)
    components_array = request.params[:learnedComponents].split(/\s*,\s*/)
    
    # Write the selected sql for target components and words
    words_select_sql = ""
    components_select_sql = ""
    
    # Iterate through the words array.
    words_array.each do |w|
      if w != words_array.first
        words_select_sql << "or "
      end
      words_select_sql << "word_id = \"#{w}\" "
    end
 
    # Iterate through the components array. 
    # Any sentence has components matched will be selected as the base collection of sentences to be searched
    components_array.each do |c|
      if c != components_array.first
        components_select_sql << "or "
      end
      components_select_sql << "name = \"#{c}\" "
    end
    
    # Use an array to store the base collection of sentences to be searched
    sentences_of_component = Array.new
    Sentence.all.each do |s|
      if !s.components.where(components_select_sql).empty?
        sentences_of_component << s
      end
    end
    
    
    # Use the base collection above, return all the sentences that contains any of the target words
    matched_sentences = Array.new
    sentences_of_component.each do |s|
      if !s.words.where(words_select_sql).empty?
        matched_sentences << s
      end
    end
    
    if(matched_sentences.empty?)
      puts "204"
      respond_to do |format|
        format.json {render json: {message: "No Sentence Found!"}, status: 204}
      end
    else
      puts "200"
      respond_to do |format|
        format.json {render json: {message: matched_sentences}, status: 200}
      end
    end
  end
end
