shared_examples_for "Add attachments" do
  background do
    sign_in(user)
    visit path
  end

  scenario "User adds files when asks the question", :js do
    fill_in "Title", with: "Title placeholder" if title?
    fill_in "Body", with: "Placeholder for body"
    attach_file "File", "#{Rails.root}/spec/rails_helper.rb"

    click_on "add file"

    within ".nested_fields:nth-child(2)" do
      attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on "add file"

    within ".nested_fields:nth-child(3)" do
      attach_file "File", "#{Rails.root}/spec/acceptance_helper.rb"
      click_on "remove file"
    end

    click_on "#{submit_btn}"

    within "#{attachment_block}" do
      expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/1/rails_helper.rb"
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/2/spec_helper.rb"
      expect(page).to_not have_link "acceptance_helper.rb", href: "/uploads/attachment/file/3/acceptance_helper.rb"
    end
  end
end
