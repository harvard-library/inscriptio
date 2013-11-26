# I know, it's silly, but Rails does it and it looks pretty...
class Integer
  def ordinalize
    n = self
    if n == 11 or n == 12
      "#{n}th"
    elsif n.to_s[-1] == '1'
      "#{n}st"
    elsif n.to_s[-1] == '2'
      "#{n}nd"
    elsif n.to_s[-1] == '3'
      "#{n}rd"
    else
      "#{n}th"
    end
  end
end

FactoryGirl.define do
  trait :named do
    sequence(:name) {|n| "#{@instance.class.to_s} #{n}"}
  end

  trait :timestamped do
    created_at Time.now
    updated_at Time.now
  end

  factory :bulletin_board do
    timestamped
    reservable_asset
    post_lifetime 3.months
  end

  sequence :cn do | n |
    s = ''
    50.times do
      s << (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['.', '-']).sample
    end
    s[0,(s.length - n.to_s.length)] + n.to_s
  end

  factory :call_number do
    timestamped
    call_number {generate :cn}
    sequence(:long_name) {|n| "CN-#{n}" }
    sequence(:description) {|n| "A #{n.ordinalize} treatise on call numbers"}
  end

  factory :floor do
    named
    timestamped
    library
    floor_map File.open('public/images/rails.png')
    position {library.floors.length + 1}
  end

  factory :library do
    named
    timestamped
    url "http://www.example.com"
    address_1 "Harvard Yard"
    address_2 "Harvard University"
    city "Cambridge"
    state "MA"
    zip "02138"
    latitude 42.374466
    longitude -71.117557
    contact_info "Telegraph or electronic mail. Interpretive dance works, too."
    description "A library. A REALLY nice one."
    tos "Be Excellent to Each Other"
    bcc "someone@authority.in"
    from  "staff@example.com"
  end

  factory :message do
    title 'Default Message'
    content 'Please create this message'
    description 'default'
  end

  factory :moderator_flag do
    timestamped
    post
    user
    reason 'User was mean'
  end

  factory :post do
    timestamped
    bulletin_board
    user
    message 'Post content'
    media 'More content?'
  end

  factory :reservable_asset_type do
    named
    library
    user_types {build_list :user_type, 3}
    timestamped
    min_reservation_time 1
    max_reservation_time 2
    max_concurrent_users 3
    has_code true
    require_moderation true
    welcome_message "Welcome to carrel"
    expiration_extension_time 3
    has_bulletin_board false
    slots 'A,B,C'
    photo File.open('public/images/rails.png')
  end

  factory :reservable_asset do
    named
    timestamped
    reservable_asset_type
    floor
    min_reservation_time 1
    max_reservation_time 2
    max_concurrent_users 3
    access_code '8675309'
    notes 'passing notes is cool'
    x1 0
    x2 10
    y1 0
    y2 10
    slots 'A,B,C'
    photo File.open('public/images/rails.png')
  end

  factory :reservation do
    timestamped
    user
    status
    reservable_asset
    tos "Be excellent to each other"
    slot "A"
    start_date Date.today
    end_date {|res| Date.today + res.reservable_asset.reservable_asset_type.max_reservation_time}
  end

  factory :reservation_notice do
    timestamped
    library
    reservable_asset_type
    status
    subject 'Reservation Approval'
    message 'Reservation approved'
    reply_to 'bum@rush.edu'
  end

  status_names = %w(Approved Pending Declined Waitlist Expired Expiring Cancelled Renewal Confirmation)
  factory :status do
    sequence(:name) {|n| status_names[n - 1] ? status_names[n - 1] : "#{n.ordinalize} status"}
  end

  factory :subject_area do
    named
    timestamped
    description { "#{name} and stuff."}
    # floors Floor.all
  end

  factory :user do
    timestamped
    sequence(:email) {|n| "user#{n}@example.com" }
    first_name "Bobbert"
    last_name "McBob"
    admin false
    password "bupkiss"
    user_type
    # school_affiliation
  end

  factory :user_type do
    named
    after(:build) do |ut, evaluator|
      ut.users << FactoryGirl.build_list(:user, 3, :user_type => ut)
    end
    timestamped
  end

end
