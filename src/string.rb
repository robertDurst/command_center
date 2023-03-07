# frozen_string_literal: true

# TODO: monkey patch this correctly
# POR String
class String
  def alpha?
    match?(/[a-zA-Z]/)
  end

  def white_space?
    match?(/\s/)
  end

  def num?
    match?(/[0-9]/)
  end

  def alpha_num_underscore?
    alpha? || num? || match?(/_/)
  end
end

