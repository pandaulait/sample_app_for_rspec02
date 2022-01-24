require 'rails_helper'

RSpec.describe Project, type: :model do
  # ユーザー単位では重複したプロジェクト名を許可しないこと
	it "does not allow duplicate project names per user" do
		user = User.create(
			first_name: "Joe",
			last_name:  "Tester",
			email:      "joetester@example.com",
			password:   "dottle-nouveau-pavilion-tights-furze",
		)
		user.projects.create(
			name: "Test Project",
			description: "test",
			due_on: Date.today,
		)
		new_project = user.projects.build(name: "Test Project", description: "test2",due_on: Date.tomorrow)
		new_project.valid?
		expect(new_project.errors[:name]).to include("has already been taken")
	end

	# 二人のユーザーが同じ名前を使うことは許可すること
	it "allows two users to share a project name" do
		user = User.create(
			first_name: "Joe",
			last_name:  "Tester",
			email:      "joetester@example.com",
			password:   "dottle-nouveau-pavilion-tights-furze",
		)
		user.projects.create(
			name: "Test Project",
			description: "test",
			due_on: Date.today,
		)
		other_user = User.create(
			first_name: "Joe2",
			last_name:  "Tester2",
			email:      "joetester2@example.com",
			password:   "dottle-nouveau-pavilion-tights-furze2",
		)

		other_project = other_user.projects.build(
			name: "Test Project",
			description: "test",
			due_on: Date.today,
		)

		expect(other_project).to be_valid
	end
end
