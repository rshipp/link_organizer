class User < ApplicationRecord
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP } # <-- validates that the email is in correct format, and that it is unique

  passwordless_with :email # <-- tells Passwordless which field stores the email address

  def self.fetch_resource_for_passwordless(email)
    find_or_create_by(email: email)
  end
end
