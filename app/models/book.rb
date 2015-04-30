class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :subjects
  belongs_to :category

  searchkick({misspellings: {edit_distance: 2},
              autocomplete: ['title'],
              suggest: ['title'],
              fields: ["title^9"]
             })


  def search_data
    as_json only: [:title, :number_of_pages,:coverimage,:publish_date,:created_at,:updated_at],
            include: [:category => { :only => [:id, :name] }]
    # {
    #     title: title,
    #     number_of_pages: number_of_pages,
    #     coverimage: coverimage,
    #     publish_date: publish_date,
    #     created_at: created_at,
    #     updated_at: updated_at,
    #     :category => {
    #         :only => [:id, :name, :slug],
    #     }
    # }
  end

  def category_name
    self.category.name
  end

  def self.import(olid)
    client = Openlibrary::Client.new
    book_data = client.book(olid)
    book = Book.new
    book.title = book_data.title
    book.number_of_pages = book_data.number_of_pages
    book.coverimage = "http://covers.openlibrary.org/b/id/#{book_data.covers.first}-M.jpg" unless book_data.covers.nil?
    book.publish_date = book_data.publish_date
    book.save!
    book_data.authors.each do |author_data|
      author_olid = author_data[:key].split("/").last
      author_name = client.author(author_olid).name
      book.authors << Author.find_or_create_by!(name: author_name)
    end
    book_data.subjects.each do |subject|
      book.subjects << Subject.find_or_create_by!(name: subject)
    end
    book
  rescue => e
    raise ImportError
  end

  class ImportError < StandardError; end
end
