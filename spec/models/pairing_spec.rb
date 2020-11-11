describe Pairing do
  it { should belong_to(:attendance_record) }
  it { should belong_to(:pair).class_name('Student') }

  let(:student) { FactoryBot.create(:student) }
  let(:pair) { FactoryBot.create(:student) }

  it 'allows creation of pairings as nested attributes on attendance record' do
    attendance_record = FactoryBot.create(:attendance_record, student: student, date: student.course.start_date, pairings_attributes: [pair_id: pair.id])
    expect(attendance_record.pairings.first.pair).to eq pair
  end

  it 'destroys pairs when destroying attendance record' do
    attendance_record = FactoryBot.create(:attendance_record, student: student, date: student.course.start_date, pairings_attributes: [pair_id: pair.id])
    expect(Pairing.any?).to eq true
    attendance_record.destroy
    expect(Pairing.any?).to eq false
  end

  it 'creates inverse if pair attendance record exists' do
    attendance_record = FactoryBot.create(:attendance_record, student: student, date: student.course.start_date)
    pair_attendance_record = FactoryBot.create(:attendance_record, student: pair, date: student.course.start_date, pairings_attributes: [pair_id: student.id])
    expect(pair_attendance_record.pairings.first.pair).to eq student
    expect(attendance_record.pairings.first.pair).to eq pair
  end
end
