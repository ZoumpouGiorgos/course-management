puts "\n== Seeding CourseManagement =="

def model?(name)
  Object.const_defined?(name) && Object.const_get(name).is_a?(Class)
end

def has_col?(klass, col)
  klass.column_names.include?(col.to_s)
rescue StandardError
  false
end

def pick(arr) = arr.sample
def sample_n(arr, n) = arr.sample([n, arr.size].min)
def rand_between(a, b) = rand(a..b)

def random_sentence(words)
  words.sample(rand_between(6, 14)).join(" ").capitalize + "."
end

def random_paragraph(words)
  Array.new(rand_between(2, 5)) { random_sentence(words) }.join(" ")
end

def random_title(words)
  words.sample(rand_between(3, 7)).map(&:capitalize).join(" ")
end

def stable_seed!
  ENV["SEED_KEY"] ||= "course_mgmt_seed"
  srand(ENV["SEED_KEY"].hash & 0xffffffff)
end

stable_seed!

WORDS = %w[
  adaptive algorithm analytics architecture assignment async backend benchmark
  capstone cloud collaboration concurrency container course crud dashboard
  database debug design devops documentation edge embedding endpoint engineering
  evaluation feedback frontend git graphql integration interface iteration
  latency lecture library lifecycle middleware microservice mobile model
  monitoring network optimization pagination pipeline performance persistence
  prototype query queue rails react refactor reliability rendering repository
  requirements routing ruby schema search security seed session solid spec sprint
  stack state storage system testing tooling ui ux validation versioning web
  websocket workflow
].freeze

GREEK_NAMES = %w[
  Giorgos Maria Nikos Eleni Dimitris Katerina Panagiotis Sofia Ioanna Kostas
  Andreas Christina Vasilis Georgia Thanos Natalia Spyros Athina Michalis
  Foteini Giannis Alexandra Petros Irene Manos Despoina Tasos
].freeze

SURNAMES = %w[
  Papadopoulos Oikonomou Georgiou Nikolaou Dimitriou Pappas Christou
  Konstantinou Angelou Karagiannis Stavrou Vrettos Zisis Koutroumanis
  Zervas Mavridis Kokkalis Zoumpos
].freeze

COURSE_CODES = %w[
  CS101 CS102 CS103 CS201 CS202 CS203 CS301 CS302 CS303
  SE101 SE201 SE301 DB101 AI201 HCI101 HCI201 NET201 WEB101 WEB201
].freeze

COURSE_TITLES = [
  "Intro to Programming",
  "Object-Oriented Programming",
  "Databases",
  "Web Development",
  "Human-Computer Interaction",
  "Software Engineering",
  "Networks & Security",
  "Algorithms & Data Structures",
  "Cloud & DevOps",
  "Machine Learning Fundamentals",
  "Information Systems",
  "UX Research & Prototyping",
  "Backend Engineering",
  "Frontend Engineering",
  "Systems Design"
].freeze

POST_TAGS = %w[
  help announcement question resources notes project exam lab homework
  tips guide tutorial bug fix
].freeze

raise "User model not found."   unless model?("User")
raise "Post model not found."   unless model?("Post")
raise "Course model not found." unless model?("Course")

user_klass   = Object.const_get("User")
post_klass   = Object.const_get("Post")
course_klass = Object.const_get("Course")

contact_klass = model?("Contact") ? Object.const_get("Contact") : nil
conv_klass    = model?("Conversation") ? Object.const_get("Conversation") : nil
cp_klass      = model?("ConversationParticipant") ? Object.const_get("ConversationParticipant") : nil
msg_klass     = model?("Message") ? Object.const_get("Message") : nil
notif_klass   = model?("Notification") ? Object.const_get("Notification") : nil

puts "Cleaning old data (if tables exist)..."
[notif_klass, msg_klass, cp_klass, conv_klass, contact_klass, post_klass, course_klass, user_klass].compact.each do |klass|
  begin
    next unless klass.table_exists?
    klass.delete_all
  rescue StandardError
  end
end

puts "Creating users..."

users = []
user_count = 60

user_count.times do |i|
  first = pick(GREEK_NAMES)
  last  = pick(SURNAMES)
  username = "#{first.downcase}_#{last.downcase}_#{i}".gsub(/[^a-z0-9_]/, "")
  email = "#{username}@example.com"

  attrs = {}
  attrs[:email] = email if has_col?(user_klass, :email)
  attrs[:username] = username if has_col?(user_klass, :username)
  attrs[:first_name] = first if has_col?(user_klass, :first_name)
  attrs[:last_name]  = last  if has_col?(user_klass, :last_name)

  pwd = "Password!#{rand(1000..9999)}"
  attrs[:password] = pwd
  attrs[:password_confirmation] = pwd

  users << user_klass.create!(attrs)
end

demo_email = "demo@example.com"
demo_user = nil

if has_col?(user_klass, :email)
  demo_user = user_klass.find_by(email: demo_email)
end

if demo_user.nil?
  demo_attrs = {}
  demo_attrs[:email] = demo_email if has_col?(user_klass, :email)
  demo_attrs[:username] = "demo_user" if has_col?(user_klass, :username)
  demo_attrs[:password] = "Password!1234"
  demo_attrs[:password_confirmation] = "Password!1234"
  demo_user = user_klass.create!(demo_attrs)
end

users.unshift(demo_user).compact!

puts "Users: #{user_klass.count}"

puts "Creating courses..."

courses = []
course_count = 18

course_count.times do |i|
  code = COURSE_CODES[i % COURSE_CODES.size]
  title = COURSE_TITLES[i % COURSE_TITLES.size]

  attrs = {}
  if has_col?(course_klass, :title)
    attrs[:title] = "#{title} (#{code})"
  elsif has_col?(course_klass, :name)
    attrs[:name] = "#{title} (#{code})"
  end
  attrs[:code] = code if has_col?(course_klass, :code)
  attrs[:semester] = %w[Winter Spring Fall].sample if has_col?(course_klass, :semester)
  attrs[:description] = random_paragraph(WORDS) if has_col?(course_klass, :description)

  courses << course_klass.create!(attrs)
end

puts "Courses: #{course_klass.count}"

puts "Creating posts..."

post_title_col =
  if has_col?(post_klass, :title) then :title
  elsif has_col?(post_klass, :name) then :name
  else nil
  end

post_body_col =
  if has_col?(post_klass, :body) then :body
  elsif has_col?(post_klass, :content) then :content
  elsif has_col?(post_klass, :description) then :description
  else nil
  end

post_user_fk   = has_col?(post_klass, :user_id) ? :user_id : nil
post_course_fk = has_col?(post_klass, :course_id) ? :course_id : nil
post_tag_col =
  if has_col?(post_klass, :tag) then :tag
  elsif has_col?(post_klass, :category) then :category
  else nil
  end

raise "Post needs a user_id column." if post_user_fk.nil?

post_count = 420
post_count.times do
  user = pick(users)
  course = pick(courses)

  attrs = {}
  attrs[post_user_fk] = user.id
  attrs[post_course_fk] = course.id if post_course_fk
  attrs[post_title_col] = random_title(WORDS) if post_title_col
  attrs[post_body_col]  = random_paragraph(WORDS) if post_body_col
  attrs[post_tag_col]   = pick(POST_TAGS) if post_tag_col

  if has_col?(post_klass, :created_at) && has_col?(post_klass, :updated_at)
    days_ago = rand_between(0, 120)
    t = Time.now - days_ago.days - rand_between(0, 86_000).seconds
    attrs[:created_at] = t
    attrs[:updated_at] = t + rand_between(0, 20_000).seconds
  end

  post_klass.create!(attrs)
end

puts "Posts: #{post_klass.count}"

contacts_enabled =
  !contact_klass.nil? &&
  begin
    contact_klass.table_exists?
  rescue StandardError
    false
  end

if contacts_enabled
  puts "Creating contacts..."

  if has_col?(contact_klass, :user_id) && has_col?(contact_klass, :contact_user_id)
    users.each do |u|
      targets = users.reject { |x| x.id == u.id }
      sample_n(targets, rand_between(8, 18)).each do |target|
        contact_klass.find_or_create_by!(user_id: u.id, contact_user_id: target.id)
      end
    end
    puts "Contacts: #{contact_klass.count}"
  else
    puts "Skipping contacts: missing user_id/contact_user_id columns."
  end
else
  puts "Skipping contacts: model/table not present."
end

conversations_enabled =
  !conv_klass.nil? && !cp_klass.nil? && !msg_klass.nil? &&
  begin
    conv_klass.table_exists? && cp_klass.table_exists? && msg_klass.table_exists?
  rescue StandardError
    false
  end

if conversations_enabled
  puts "Creating conversations, participants, and messages..."

  msg_body_col =
    if has_col?(msg_klass, :body) then :body
    elsif has_col?(msg_klass, :content) then :content
    else nil
    end
  raise "Message needs body/content column." if msg_body_col.nil?

  conv_count = 65
  msg_per_conv_min = 6
  msg_per_conv_max = 28

  conv_count.times do
    group = rand < 0.25
    participants = group ? sample_n(users, rand_between(3, 7)) : sample_n(users, 2)

    c_attrs = {}
    c_attrs[:title] = "Chat: #{participants.map { |u| u.respond_to?(:username) ? u.username : u.id }.join(", ")}" if has_col?(conv_klass, :title)
    conversation = conv_klass.create!(c_attrs)

    participants.each do |u|
      cp_klass.find_or_create_by!(conversation_id: conversation.id, user_id: u.id)
    end

    msg_count = rand_between(msg_per_conv_min, msg_per_conv_max)
    base_time = Time.now - rand_between(0, 60).days

    msg_count.times do |idx|
      sender = pick(participants)
      m_attrs = {
        conversation_id: conversation.id,
        user_id: sender.id,
        msg_body_col => random_paragraph(WORDS)
      }

      if has_col?(msg_klass, :created_at) && has_col?(msg_klass, :updated_at)
        t = base_time + (idx * rand_between(30, 420)).seconds
        m_attrs[:created_at] = t
        m_attrs[:updated_at] = t
      end

      msg_klass.create!(m_attrs)
    end
  end

  puts "Conversations: #{conv_klass.count}"
  puts "ConversationParticipants: #{cp_klass.count}"
  puts "Messages: #{msg_klass.count}"
else
  puts "Skipping conversations/messages: models/tables not present."
end

notifications_enabled =
  !notif_klass.nil? &&
  begin
    notif_klass.table_exists?
  rescue StandardError
    false
  end

if notifications_enabled
  puts "Creating notifications..."

  notif_text_col =
    if has_col?(notif_klass, :message) then :message
    elsif has_col?(notif_klass, :body) then :body
    elsif has_col?(notif_klass, :content) then :content
    else nil
    end

  recipient_col =
    if has_col?(notif_klass, :user_id) then :user_id
    elsif has_col?(notif_klass, :recipient_id) then :recipient_id
    else nil
    end

  read_col =
    if has_col?(notif_klass, :read) then :read
    elsif has_col?(notif_klass, :read_at) then :read_at
    else nil
    end

  if notif_text_col && recipient_col
    users.each do |u|
      rand_between(6, 18).times do
        text = [
          "New message in your conversations.",
          "Someone replied to a post you follow.",
          "A new post was added to a course.",
          "Contact update.",
          "Reminder: check recent posts.",
          random_sentence(WORDS)
        ].sample

        n_attrs = { recipient_col => u.id, notif_text_col => text }

        if read_col == :read
          n_attrs[:read] = (rand < 0.55)
        elsif read_col == :read_at
          n_attrs[:read_at] = (rand < 0.55) ? (Time.now - rand_between(1, 20).days) : nil
        end

        if has_col?(notif_klass, :created_at) && has_col?(notif_klass, :updated_at)
          t = Time.now - rand_between(0, 45).days - rand_between(0, 86_000).seconds
          n_attrs[:created_at] = t
          n_attrs[:updated_at] = t
        end

        notif_klass.create!(n_attrs)
      end
    end

    puts "Notifications: #{notif_klass.count}"
  else
    puts "Skipping notifications: couldn't detect text/recipient columns."
  end
else
  puts "Skipping notifications: model/table not present."
end

puts "Adding extra posts to a few hot courses..."
hot_courses = sample_n(courses, 4)
extra_posts = 160

extra_posts.times do
  user = pick(users)
  course = pick(hot_courses)

  attrs = {}
  attrs[post_user_fk] = user.id
  attrs[post_course_fk] = course.id if post_course_fk
  attrs[post_title_col] = "[HOT] #{random_title(WORDS)}" if post_title_col
  attrs[post_body_col]  = random_paragraph(WORDS) if post_body_col
  attrs[post_tag_col]   = %w[announcement exam resources notes].sample if post_tag_col

  if has_col?(post_klass, :created_at) && has_col?(post_klass, :updated_at)
    t = Time.now - rand_between(0, 20).days - rand_between(0, 86_000).seconds
    attrs[:created_at] = t
    attrs[:updated_at] = t
  end

  post_klass.create!(attrs)
end

puts "\n== Done =="
puts "Users: #{user_klass.count}"
puts "Courses: #{course_klass.count}"
puts "Posts: #{post_klass.count}"
puts "Contacts: #{contacts_enabled ? contact_klass.count : "n/a"}"
puts "Conversations: #{conversations_enabled ? conv_klass.count : "n/a"}"
puts "Messages: #{conversations_enabled ? msg_klass.count : "n/a"}"
puts "Notifications: #{notifications_enabled ? notif_klass.count : "n/a"}"

puts
puts "Demo login:"
puts "  email: demo@example.com"
puts "  password: Password!1234"
puts
