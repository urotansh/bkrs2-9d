class SearchesController < ApplicationController
  
  def search
    
    if params[:tag]
      @keyword = params[:keyword]
      search = "perfect_match"
      column = "tag"
      @results = Book.search_for(@keyword, search, column)
    
    else
      @keyword = params[:keyword]
      target = params[:target]
      search = params[:search]
      obj = Object.const_get(target)
      
      if @keyword.present?
        if target == "User"
          #検索カラム
          column = "name"
          @results = User.search_for(@keyword, search, column)
        elsif target == "Book"
          #検索カラム
          column = "title"
          @results = Book.search_for(@keyword, search, column)
        else
          redirect_to request.referer
        end
      else
        @results = obj.none
      end
      
    end
    
  end
  
end
