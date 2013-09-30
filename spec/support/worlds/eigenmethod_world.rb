module EigenmethodWorld

  def stub_eigenmethods(klass)
    klass.stub(:eigenmethods).and_return([])
  end

end