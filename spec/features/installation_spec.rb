require "rails_helper"

feature 'Install the software.' do
  scenario 'supply keys and hit go.', :js => true do
    
    visit root_path
    
    fill_in 'cold_storage_mpk', :with => 'xpub69GZWTQPtwQRriHyYuYJpDgAUrHHRD8ksBbQ61QpY1CbSUrcW7udYcZ1YLuLVtSQx9xW5QApiGidDfmFVLEz4Lep3AoCGD2HQmfvXwH1GMt'
    
    click_on "Save"
    
    expect(page).to have_text 'BitDice Register'
    
  end
end