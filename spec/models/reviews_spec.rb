require File.dirname(__FILE__) + '/../spec_helper'

describe Spree::Review do
  before(:each) do
    user = Factory(:user)
    @review = Spree::Review.new(:name => "blah", :rating => "2", :review => "great", :user => user)
  end

  context "creating a new wishlist" do
    it "is valid with valid attributes" do
      @review.should be_valid
    end

    it "is not valid without a rating" do
      @review.rating = nil
      @review.should_not be_valid
    end

    it "is not valid unless the rating is an integer" do
      @review.rating = 2.0
      @review.should_not be_valid
    end

    it "is not valid without a review body" do
      @review.review = nil
      @review.should_not be_valid
    end
  end

  context "#feedback_stars" do
    before(:each) do
      @review.save
      3.times { |i| Spree::FeedbackReview.create(:review => @review, :rating => (i+1)) }
    end

    it "should return the average rating from feedback reviews" do
      @review.feedback_stars.should == 2
    end
  end
end
