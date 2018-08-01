# This concern is used to assist with actions that require transactional rollback
# capabilities. Basic implementation is as follows:
#
#  around_filter :wrap_in_transaction, only: :show
#
#  In this case you would have the ability to call `rollback` inside the action
#  to rollback any data changes that have been made.
#
#  around_filter :rollback_on_complete, only: :show
#
#  In this case a rollback imminent. You are requesting that the data created
#  in this action is only temporary to display to the user. Note that an "around"
#  filter also wraps rendering.
#

module Transactionable
  extend ActiveSupport::Concern

  def rollback_on_complete
    ActiveRecord::Base.transaction do
      begin
        yield
      ensure
        rollback
      end
    end
  end

  def wrap_in_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end

  def rollback
    raise ActiveRecord::Rollback
  end

end