class Conversation < ApplicationRecord

  belongs_to :author, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :author, uniqueness: {scope: :receiver}

  has_many :personal_messages, -> { order(created_at: :asc) }, dependent: :destroy

  scope :participating, -> (user) do
  where("(conversations.author_id = ? OR conversations.receiver_id = ?)", user.id, user.id)
  end

end