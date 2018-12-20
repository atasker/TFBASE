class RenameNoFeeMessageToFaceValueInTickets < ActiveRecord::Migration[5.2]
  def change
    rename_column :tickets, :no_fee_message, :face_value
  end
end
