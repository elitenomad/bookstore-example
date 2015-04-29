class BooksController < ApplicationController
  def index
    if params[:query].present?
      @books = Book.search(params[:query].split(' ')[0], page: params[:page])
     # @suggestions = @books.suggestions
    else
      @books = Book.all.page params[:page]
    end
  end

  def autocomplete
    @book_searches = Book.search(params[:query],facets: [:name], autocomplete: true,  limit: 10).facets["name"]["terms"].sort_by{|t| t.count}.map{|t| "#{params[:query]} in #{t['term']}"}
   # binding.pry
    render json: @book_searches
  end

  def import
    book = Book.import params[:olid]
    notice = "Imported #{book.title}"
    redirect_to books_path, notice: notice
  rescue Book::ImportError
    redirect_to books_path, alert: "Failed to import book"
  end
end
