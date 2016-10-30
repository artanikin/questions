FactoryGirl.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/spec_helper.rb"))}
    attachable nil
  end
end
