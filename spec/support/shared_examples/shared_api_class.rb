shared_examples_for "ApiClass" do

  it "that has #api_method class method" do
    expect(subject.class).to respond_to(:api_method)
  end

end