class RemovePairIdsFromAttendanceRecord < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendance_records, :pair_ids, :integer
  end
end
