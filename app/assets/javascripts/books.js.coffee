$ ->
  $('#book_search').typeahead
    name: "book"
    remote: "/books/autocomplete?query=%QUERY"
    limit: 20
