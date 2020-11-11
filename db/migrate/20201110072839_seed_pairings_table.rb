class SeedPairingsTable < ActiveRecord::Migration[5.2]
  def change
    AttendanceRecord.where.not(pair_ids: []).each do |ar|
      ar.pair_ids.each do |pair_id|
        ar.pairings << Pairing.new(pair_id: pair_id)
      end
    end
  end
end
