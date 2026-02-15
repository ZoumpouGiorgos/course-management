courses = [
  { title: "Algorithms & Data Structures", code: "CS201", credits: 6 },
  { title: "Discrete Mathematics", code: "CS202", credits: 5 },
  { title: "Computer Architecture", code: "CS203", credits: 6 },
  { title: "Object-Oriented Programming", code: "CS204", credits: 6 },
  { title: "Introduction to Programming", code: "CS101", credits: 6 },

  { title: "Databases", code: "CS301", credits: 6 },
  { title: "Operating Systems", code: "CS302", credits: 6 },
  { title: "Computer Networks", code: "CS303", credits: 5 },
  { title: "Software Engineering", code: "CS304", credits: 6 },
  { title: "Web Technologies", code: "CS305", credits: 5 },

  { title: "Distributed Systems", code: "CS401", credits: 6 },
  { title: "Information Security", code: "CS402", credits: 5 },
  { title: "Artificial Intelligence", code: "CS403", credits: 6 },
  { title: "Machine Learning", code: "CS404", credits: 6 },
  { title: "Data Mining", code: "CS405", credits: 5 },

  { title: "Human-Computer Interaction", code: "CS406", credits: 5 },
  { title: "Mobile Application Development", code: "CS407", credits: 5 },
  { title: "Cloud Computing", code: "CS408", credits: 5 },
  { title: "DevOps & CI/CD", code: "CS409", credits: 5 },
  { title: "Computer Graphics", code: "CS410", credits: 5 },

  { title: "Parallel Programming", code: "CS411", credits: 5 },
  { title: "Compilers", code: "CS412", credits: 6 },
  { title: "Theory of Computation", code: "CS413", credits: 5 },
  { title: "Embedded Systems", code: "CS414", credits: 5 },
  { title: "Numerical Methods", code: "CS415", credits: 5 },

  { title: "IT Project Management", code: "CS416", credits: 4 },
  { title: "Research Methods in CS", code: "CS417", credits: 4 },
  { title: "Capstone Project", code: "CS498", credits: 8 }
]

courses.each do |course|
  Course.find_or_create_by!(code: course[:code]) do |c|
    c.title = course[:title]
    c.credits = course[:credits]
  end
end

puts "Seeded #{Course.count} courses"