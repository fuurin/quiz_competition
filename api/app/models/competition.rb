class Competition < ApplicationRecord
  belongs_to :quiz_set
  belongs_to :quiz
  has_many :users, dependent: :destroy
  has_many :answers, dependent: :destroy

  enum status: { question: 0, answer: 1, result: 2 }

  validates :status, presence: true
  validates :rid, presence: true

  before_validation :set_first_quiz, :set_rid, on: :create

  def result
    return [] if users.empty?

    # クイズの途中であれば、現在開示しているところまでの結果発表を行う
    quizzes = quiz_set.quizzes.where("number <#{'=' unless question?} #{quiz.number}")

    # 全出題クイズを取得
    quiz_map = quizzes.each_with_object({}).with_index { |(q, m), i| m[q.id] = i }

    # 全参加ユーザを取得
    user_map = users.each_with_object({}).with_index { |(u, m), i| m[u.id] = i }
    
    # ユーザ × 問題 の二次元テーブルを作り、正解していれば1, 不正解・答えなしなら0を入れる
    result_table = Array.new(user_map.size).map{ Array.new(quiz_map.size, 0) }
    answers.includes(:option).each do |answer|
      next unless answer.option.is_correct_answer
      result_table[user_map[answer.user_id]][quiz_map[answer.quiz_id]] = 1
    end

    # name, email, 正解数, 正誤履歴からなるオブジェクトを正解数が大きい順に取得
    result = users.map do |user|
      {
        name: user.name,
        email: user.email,
        correct_num: result_table[user_map[user.id]].sum,
      }.merge(
        result_table[user_map[user.id]].each_with_object({}).with_index do |(r, m), i|
          m["q#{i+1}".to_sym] = r.zero? ? '×' : '○'
        end
      )
    end.sort { |a, b| b[:correct_num] <=> a[:correct_num] }

    # タイを考慮した順位付けを行う
    rank = 1
    prev_correct_num = result.first[:correct_num]
    result.each do |r|
      if prev_correct_num > r[:correct_num]
        rank += 1
      end
      prev_correct_num = r[:correct_num]
      r[:rank] = rank
    end

    result
  end

  private

  def set_first_quiz
    self.quiz = quiz_set.quizzes.first
  end

  def set_rid
    if quiz_set.title == Settings.wedding.title
      self.rid = Settings.wedding.id
      return
    end

    loop do
      self.rid = SecureRandom.alphanumeric(Settings.models.competition.rid_length)
      return unless Competition.find_by(rid: rid)
    end
  end
end
