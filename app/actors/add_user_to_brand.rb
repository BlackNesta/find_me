class AddUserToBrand < Actor
  input :brand
  input :user_id        # an existing user picked from the dropdown
  input :user_params    # a new user being created
  input :setting_params

  output :brand_user

  # Creates the membership and its setting in one transaction, so a failed
  # membership never leaves a half-created user behind.
  def call
    self.brand_user = brand.brand_users.new(user: resolve_user)
    brand_user.build_setting(setting_params || {})

    ActiveRecord::Base.transaction do
      brand_user.user.save! if brand_user.user&.new_record?
      brand_user.save!
    end
  rescue ActiveRecord::RecordInvalid
    gather_errors
  rescue ActiveRecord::RecordNotUnique
    brand_user.errors.add(:base, "User is already added to this brand")
  end

  private

  def resolve_user
    user_id.present? ? User.find(user_id) : User.new(user_params || {})
  end

  def gather_errors
    [brand_user.user, brand_user.setting].compact.each do |record|
      record.errors.full_messages.each { |message| brand_user.errors.add(:base, message) }
    end
  end
end
