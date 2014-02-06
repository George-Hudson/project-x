require 'spec_helper'

describe "dashboard index", :vcr do

  before do
    @user = FactoryGirl.create(:user)
    food = FactoryGirl.create(:food, user_id: @user.id, calories: 34532349)
    login_user(@user)
    visit login_path
    click_on "Sign in with Fitbit"
  end

  it "has views for sleep and steps" do
    expect(page).to have_content 'steps'
  end

  it "has views for sleep" do
    expect(page).to have_content 'hours'
  end

  it "has a View User Profile button" do
    expect(page).to have_content 'View My Profile'
  end

  it "has a User's food daily food info" do 
    expect(page).to have_content(@user.calorie_total_for(Date.today))
    expect(page).to have_content(@user.protein_total_for(Date.today))
    expect(page).to have_content(@user.fiber_total_for(Date.today))
    expect(page).to have_content(@user.fat_total_for(Date.today))
    expect(page).to have_content(@user.carb_total_for(Date.today))
  end

end
