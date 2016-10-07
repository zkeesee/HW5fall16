# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end

# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  allratings = ['G', 'PG', 'PG-13', 'NC-17', 'R']
  allratings.each do |x|
    uncheck "ratings_#{x}"
  end
  rating_list = arg1.split(", ")
  rating_list.each do |ratingInd|
    check "ratings_#{ratingInd}"
  end
  click_button "ratings_submit"
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    testCase = false
    all("table#movies tr/td[2]").each do |ratingValue|
        if (ratingValue.text.in?(arg1.split(",")))
            testCase = true
        end
    end
    expect(testCase).to be_truthy
end

Then /^I should see all of the movies$/ do
    numberOfMovies = all("table#movies tr").count-14
    expect(Movie.all.count == numberOfMovies).to be_truthy
end

When /^I have opted to see the movies in alphabetical order$/ do
    click_on "title_header"
end

Then /^I should see the title "(.*?)" before "(.*?)"$/ do |titleOne,titleTwo|
    movieList = []
    all("table#movies tbody/tr/td[1]").each do |movieTitle|
        #push all movies onto movieList
        movieList << movieTitle.text
    end
    expect(movieList.index(titleOne) < movieList.index(titleTwo)).to be_truthy
end

When /^I have opted to see the movies in increasing order of release date$/ do
    click_on "release_date_header"
end

Then /^I should see the date "(.*?)" before "(.*?)"$/ do |dateOne,dateTwo|
    movieList = []
    all("table#movies tbody/tr/td[3]").each do |movieDate|
        #push all movies onto movieList
        movieList << movieDate.text
    end
    expect(movieList.index(dateOne) < movieList.index(dateTwo)).to be_truthy
end