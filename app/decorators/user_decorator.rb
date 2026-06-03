class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def display
    "#{full_name} (#{email})"
  end
end
