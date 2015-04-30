class BooksController < ApplicationController
  def index
    if params[:query].present?
      search_str = params[:query]
      search_query = ''
      if search_str.index(' in ').to_i > 0
        search_query = search_str.slice(0..search_str.index(' in '))
      else
        search_query = search_str
      end
      @books = Book.search(search_query, page: params[:page])
     # @suggestions = @books.suggestions
    else
      @books = Book.all.page params[:page]
    end
  end

  def autocomplete
    @book_searches = Book.search(params[:query], autocomplete: true,  limit: 5).map(&:title)
    @book_searches_in_categories = Book.search(@book_searches[0].split(" ")[0], facets: [:name], autocomplete: true,  limit: 5).facets["name"]["terms"].sort_by{|t| t.count}.map{|t| "#{@book_searches[0]} in #{t['term']}"}
    # facets: [:name]
       # facets["name"]["terms"].sort_by{|t| t.count}.map{|t| "#{params[:query]} in #{t['term']}"}
    @all_searches = @book_searches_in_categories + @book_searches
   # binding.pry
    render json: @all_searches
  end

  def import
    book = Book.import params[:olid]
    notice = "Imported #{book.title}"
    redirect_to books_path, notice: notice
  rescue Book::ImportError
    redirect_to books_path, alert: "Failed to import book"
  end
end
