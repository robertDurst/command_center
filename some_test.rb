class SomeClass
  def initialize(some_var:)
    @some_var = some_var
  end

  def get_some_Var
    some_var
  end

  private

  attr_reader :some_var
end
