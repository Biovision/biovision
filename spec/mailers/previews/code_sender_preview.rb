# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class CodeSenderPreview < ActionMailer::Preview
  def password
    CodeSender.password(Code.last.id)
  end
end
