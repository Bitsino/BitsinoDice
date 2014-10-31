FactoryGirl.define do
  factory :balance do
    user_id 1
    amount 500000
    transaction_hash "dbb4fa1da1d6d53911c45b52d94d38507c3f27fa245a7e58bb2d7e6e7056ed72"
  end
  
  trait :big_spender do
    amount 500000000
  end
end
