shared_examples_for "CollectionChild" do |type|

  it "that has #api_method class method" do
    expect(type.superclass).to eq Seatbelt::Collections::Collection
  end

end