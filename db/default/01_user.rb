# frozen_string_literal: true

# Initialize default admin user
User.first_or_create(email: 'hoanghiepitvnn@gmail.com', password: '12345678')
