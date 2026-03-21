# Seed data for PropBet Social Prediction Market

puts "Creating users..."
alice = User.find_or_create_by!(email: 'alice@example.com') { |u| u.name = 'Alice'; u.balance = 250 }
bob   = User.find_or_create_by!(email: 'bob@example.com')   { |u| u.name = 'Bob';   u.balance = 180 }
carol = User.find_or_create_by!(email: 'carol@example.com') { |u| u.name = 'Carol'; u.balance = 320 }
dave  = User.find_or_create_by!(email: 'dave@example.com')  { |u| u.name = 'Dave';  u.balance = 95  }

puts "Creating pools..."
school_pool = Pool.find_or_create_by!(name: 'College Squad') do |p|
  p.creator = alice
  p.pool_type = 'public'
end
[alice, bob, carol, dave].each { |u| school_pool.pool_memberships.find_or_create_by!(user: u) }

office_pool = Pool.find_or_create_by!(name: 'Office Sharks') do |p|
  p.creator = bob
  p.pool_type = 'private'
end
[bob, carol].each { |u| office_pool.pool_memberships.find_or_create_by!(user: u) }

puts "Creating markets..."
unless Market.exists?(title: "Will Dave show up late to Monday's meeting?")
  m1 = Market.create!(
    title: "Will Dave show up late to Monday's meeting?",
    description: "Dave has been late 3 weeks in a row. Will the streak continue?",
    market_type: 'binary',
    status: 'open',
    house_cut_pct: 5,
    creator: alice,
    pool: school_pool,
    subject_name: 'Dave',
    end_time: 3.days.from_now,
    total_pool: 0
  )
  yes_opt = m1.market_options.create!(label: 'Yes', total_amount: 0)
  no_opt  = m1.market_options.create!(label: 'No',  total_amount: 0)

  # Simulate some bets
  [
    [bob, yes_opt, 25],
    [carol, no_opt, 15],
    [alice, yes_opt, 40],
  ].each do |user, opt, amount|
    user.reload
    next if user.balance < amount
    user.decrement!(:balance, amount)
    opt.increment!(:total_amount, amount)
    m1.increment!(:total_pool, amount)
    m1.bets.create!(user: user, market_option: opt, amount: amount, anonymous: false, settled: false)
  end
end

unless Market.exists?(title: "Will Sarah post more than 5 stories this week?")
  m2 = Market.create!(
    title: "Will Sarah post more than 5 stories this week?",
    description: "Sarah has been very active on social media lately.",
    market_type: 'binary',
    status: 'open',
    house_cut_pct: 5,
    creator: carol,
    pool: nil,
    subject_name: 'Sarah',
    end_time: 7.days.from_now,
    total_pool: 0
  )
  yes_opt = m2.market_options.create!(label: 'Yes', total_amount: 0)
  no_opt  = m2.market_options.create!(label: 'No',  total_amount: 0)

  [
    [alice, yes_opt, 30],
    [dave, no_opt, 20],
  ].each do |user, opt, amount|
    next if user.balance < amount
    user.decrement!(:balance, amount)
    opt.increment!(:total_amount, amount)
    m2.increment!(:total_pool, amount)
    m2.bets.create!(user: user, market_option: opt, amount: amount, anonymous: false, settled: false)
  end
end

unless Market.exists?(title: "Which movie will Bob suggest for Friday night?")
  m3 = Market.create!(
    title: "Which movie will Bob suggest for Friday night?",
    description: "Bob always picks something obscure. What will it be this week?",
    market_type: 'multi',
    status: 'open',
    house_cut_pct: 8,
    creator: alice,
    pool: school_pool,
    subject_name: 'Bob',
    end_time: 5.days.from_now,
    total_pool: 0
  )
  horror = m3.market_options.create!(label: 'Horror film', total_amount: 0)
  action = m3.market_options.create!(label: 'Action film', total_amount: 0)
  indie  = m3.market_options.create!(label: 'Indie/Arthouse', total_amount: 0)

  [
    [carol, horror, 20],
    [dave, indie, 35],
    [alice, action, 15],
  ].each do |user, opt, amount|
    next if user.balance < amount
    user.decrement!(:balance, amount)
    opt.increment!(:total_amount, amount)
    m3.increment!(:total_pool, amount)
    m3.bets.create!(user: user, market_option: opt, amount: amount, anonymous: false, settled: false)
  end
end

puts "Seed complete! #{User.count} users, #{Pool.count} pools, #{Market.count} markets, #{Bet.count} bets."
