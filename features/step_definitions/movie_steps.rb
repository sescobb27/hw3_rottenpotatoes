# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create movie
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  all_movies ||= page.all 'table#movies tbody tr'
  movie_names ||= []
  all_movies.each do |movie_row|
    if movie_row.has_text? e1
      movie_names << e1
    elsif movie_row.has_text? e2
      movie_names << e2
    end
  end
  movie_names[0].should == e1 and movie_names[1].should == e2
end

Then /^I should see all of the movies$/ do
  rows = page.all 'table#movies tbody tr'
  rows.count.should == 10
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /^I (un)?check the following ratings: (.*)$/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(', ')
  if 'un' == uncheck
    ratings.each do |rating|
      uncheck "ratings_#{rating}"
    end
  else
    ratings.each do |rating|
      check "ratings_#{rating}"
    end
  end
end

Then /^the director of \"(.*)\" should be \"(.*)\"$/ do |movie, director|
  movie = Movie.where(director: director, title: movie).first
  true unless movie.should_not == nil 
end