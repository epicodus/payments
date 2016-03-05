describe Internship do
  it { should belong_to :course }
  it { should belong_to :company }
  it { should have_many :ratings }
  it { should have_many(:students).through(:ratings) }
  it { should validate_presence_of :course_id }
  it { should validate_presence_of :company_id }
  it { should validate_presence_of :description }
  it { should validate_presence_of :ideal_intern }
  it { should validate_presence_of :name }
  it { should validate_presence_of :website }

  describe "validations" do
    subject { FactoryGirl.build(:internship) }
    it { should validate_uniqueness_of(:company_id).scoped_to(:course_id) }
  end

  describe 'default scope' do
    let!(:internship) { FactoryGirl.create(:internship, name: "z labs") }
    let!(:internship_two) { FactoryGirl.create(:internship, name: "a labs") }
    let!(:internship_three) { FactoryGirl.create(:internship, name: 'k labs') }

    it 'should be organized alphabetically by name' do

      expect(Internship.all).to eq [internship_two, internship_three, internship]
    end
  end

  describe '#fix_url' do
    it 'strips whitespace from url' do
      internship = FactoryGirl.create(:internship, website: 'http://www.test.com    ')
      expect(internship.website).to eq 'http://www.test.com'
    end

    it 'returns false with invalid url' do
      internship = FactoryGirl.build(:internship, website: 'http://].com')
      expect(internship.save).to eq false
    end

    context 'with a valid uri scheme' do
      it "doesn't prepend 'http://' to the url when it starts with 'http:/" do
        internship = FactoryGirl.create(:internship, website: 'http://www.test.com')
        expect(internship.website).to eq 'http://www.test.com'
      end
    end

    context 'with an invalid uri scheme' do
      it "prepends 'http://' to the url when it doesn't start with 'http" do
        internship = FactoryGirl.create(:internship, website: 'www.test.com')
        expect(internship.website).to eq 'http://www.test.com'
      end
    end
  end
end
