class DailyMail < ApplicationMailer

  def for(user, pockets)
    @user    = user
    @pockets = pockets.map{ |pocket| PocketDecorator.new(pocket) }

    # ahoy_email
    track user: @user

    mail(
      to: @user.email,
      subject: subject(@pockets)
    )
  end

  private

    def subject(pockets)
      _subject  = "Today's Reread - #{pockets.first.resolved_title}"
      _subject += ", and more" if pockets.count > 1
      _subject
    end
end
