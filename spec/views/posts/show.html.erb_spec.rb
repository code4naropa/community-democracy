require 'rails_helper'

RSpec.describe "posts/show", type: :view do
  before(:each) do
    @post = assign(:post, create(:post, :content => "Some text"))
  end

  it "renders author, content, and timestamp" do
    render
    expect(rendered).to match(@post.author.name)
    expect(rendered).to match(/Some text/)
    expect(rendered).to match(render_timestamp(@post.created_at))
  end

  it "shows new comment form if user is signed in" do
    @current_user = create(:user)
    render
    expect(rendered).to match("New Comment")
  end

  it "does not show new comment form if user is not signed in" do
    @current_user = nil
    render
    expect(rendered).not_to match("New Comment")
  end

end
