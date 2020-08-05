feature 'Visiting the pair feedback index page' do
  let(:student) { FactoryBot.create(:user_with_all_documents_signed) }
  let!(:pair) { FactoryBot.create(:user_with_all_documents_signed, courses: [student.course]) }

  context 'as an admin' do
    let(:admin) { FactoryBot.create(:admin) }
    before { login_as(admin, scope: :admin) }

    scenario 'you can navigate to view pair feedback' do
      visit student_courses_path(pair)
      click_on 'Pair Feedback'
      expect(page).to have_content "Evaluator"
    end

    scenario 'you can view pair feedback for a student' do
      pair_feedback = FactoryBot.create(:pair_feedback, student: student, pair: pair)
      visit student_pair_feedbacks_path(pair)
      expect(page).to have_content student.name
      expect(page).to have_content pair_feedback.score
    end
  end

  context 'as a student' do
    before { login_as(student, scope: :student) }

    context 'you can not view pair feedback' do
      let!(:pair_feedback) { FactoryBot.create(:pair_feedback) }

      scenario 'written by you' do
        visit student_pair_feedbacks_path(student)
        expect(page).to have_content 'You are not authorized'
      end

      scenario 'written about you' do
        visit student_pair_feedbacks_path(pair)
        expect(page).to have_content 'You are not authorized'
      end
    end

    context 'submitting pair feedback' do
      scenario 'you can navigate to the new feedback form' do
        visit '/pair_feedback'
        expect(page).to have_content "Daily Pair Feedback Questions"
      end

      scenario 'you can submit with all fields' do
        visit '/pair_feedback'
        select pair.name, from: 'peer-eval-select-name'
        choose 'pair_feedback_q1_response_1'
        choose 'pair_feedback_q2_response_2'
        choose 'pair_feedback_q3_response_3'
        find('textarea').set('foo')
        click_on 'Submit pair feedback'
        expect(page).to have_content "Pair feedback submitted"
        feedback = PairFeedback.last
        expect(feedback.student).to eq student
        expect(feedback.pair).to eq pair
        expect(feedback.q1_response).to eq 1
        expect(feedback.q2_response).to eq 2
        expect(feedback.q3_response).to eq 3
        expect(feedback.comments).to eq 'foo'
      end

      scenario 'you can submit without comments' do
        visit '/pair_feedback'
        select pair.name, from: 'peer-eval-select-name'
        choose 'pair_feedback_q1_response_1'
        choose 'pair_feedback_q2_response_2'
        choose 'pair_feedback_q3_response_3'
        click_on 'Submit pair feedback'
        expect(page).to have_content "Pair feedback submitted"
      end

      scenario 'you can not submit if missing pair' do
        visit '/pair_feedback'
        choose 'pair_feedback_q1_response_1'
        choose 'pair_feedback_q2_response_2'
        choose 'pair_feedback_q3_response_3'
        click_on 'Submit pair feedback'
        expect(page).to have_content "Pair must exist"
      end

      scenario 'you can not submit if missing q1' do
        visit '/pair_feedback'
        select pair.name, from: 'peer-eval-select-name'
        choose 'pair_feedback_q2_response_2'
        choose 'pair_feedback_q3_response_3'
        click_on 'Submit pair feedback'
        expect(page).to have_content "Q1 response can't be blank"
      end

      scenario 'you can not submit if missing q2' do
        visit '/pair_feedback'
        select pair.name, from: 'peer-eval-select-name'
        choose 'pair_feedback_q1_response_1'
        choose 'pair_feedback_q3_response_3'
        click_on 'Submit pair feedback'
        expect(page).to have_content "Q2 response can't be blank"
      end

      scenario 'you can not submit if missing q3' do
        visit '/pair_feedback'
        select pair.name, from: 'peer-eval-select-name'
        choose 'pair_feedback_q1_response_1'
        choose 'pair_feedback_q2_response_2'
        click_on 'Submit pair feedback'
        expect(page).to have_content "Q3 response can't be blank"
      end
    end
  end
end