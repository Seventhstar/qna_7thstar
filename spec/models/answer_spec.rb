require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_db_index(:question_id) }
  it { should have_db_index(:user_id) }


  describe 'set best to instance' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:other_answer) { create(:answer, question: question, best: true) }

    it 'should set best true to instance' do
      answer.set_best
      expect(answer).to be_best
    end

    it 'should set best false to all other answers for the question' do
      answer.set_best
      other_answer.reload
      expect(other_answer).to_not be_best
    end
  end

  describe 'order answers' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question: question) }
    let!(:other_answer) { create(:answer, question: question, best: true) }

    it 'should move best answer at first' do
      expect(question.answers.first.id).to eq other_answer.id
    end
  end


end
