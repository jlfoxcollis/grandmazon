class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates_presence_of :last_name
  has_one :merchant
  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items


  def self.top_five_customers
   # joins(:transactions)
   # .select("customers.*, count('transactions.result') AS transaction_count")
   # .group(:id)
   # .where('transactions.result = ?', 1)
   # .order('transaction_count desc')
   # .limit(5)
  end

  def successful_purchases
    # transactions.where('result = ?', 1).count
  end

  def name
    # first_name + " " + last_name
  end

         # create_table "users", force: :cascade do |t|
         #   t.string "email", default: "", null: false
         #   t.string "encrypted_password", default: "", null: false
         #   t.string "first_name"
         #   t.string "last_name"
         #   t.boolean "admin", default: false
         #   t.boolean "merchant", default: false
         #   t.bigint "merchants_id"
         #   t.string "reset_password_token"
         #   t.datetime "reset_password_sent_at"
         #   t.datetime "remember_created_at"
         #   t.datetime "created_at", null: false
         #   t.datetime "updated_at", null: false
         #   t.index ["email"], name: "index_users_on_email", unique: true
         #   t.index ["merchants_id"], name: "index_users_on_merchants_id"
         #   t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
         # end
end
