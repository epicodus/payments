class Pairing < ApplicationRecord
  belongs_to :attendance_record
  belongs_to :pair, class_name: 'Student'

  after_create :create_inverse, if: :pair_attendance_record
  after_destroy :destroy_inverse, if: :pair_attendance_record

private
  def create_inverse
    pair_attendance_record.pairings.find_or_create_by(pair_id: student_id)
  end

  def destroy_inverse
    pair_attendance_record.pairings.find_by(pair_id: student_id).try(:destroy)
  end

  def pair_attendance_record
    pair.attendance_record_on_day(attendance_record.date)
  end

  def student_id
    attendance_record.student_id
  end
end
