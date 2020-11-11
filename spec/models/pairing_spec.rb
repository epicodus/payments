describe Pairing do
  it { should belong_to(:attendance_record) }
  it { should belong_to(:pair).class_name('Student') }

  let(:student) { FactoryBot.create(:student) }
  let(:pair) { FactoryBot.create(:student) }
  let!(:attendance_record) { FactoryBot.create(:attendance_record, student: student, date: student.course.start_date, pairings_attributes: [pair_id: pair.id]) }

  it 'allows creation of pairings as nested attributes on attendance record' do
    expect(attendance_record.pairings.first.pair).to eq pair
  end

  it 'destroys pairs when destroying attendance record' do
    expect(Pairing.any?).to eq true
    attendance_record.destroy
    expect(Pairing.any?).to eq false
  end
end
