require 'spec_helper'

describe "Product pages" do
  def step_1?
    has_selector?("input[type!='hidden'], textarea", count: 3) && find('#product_current_step').value() == "0"
  end

  def step_2?
    has_selector?("input[type!='hidden']", count: 5) && find('#product_current_step').value() == "1"
  end

  def step_3?
    has_selector?("input[type!='hidden'], select, textarea", count: 8) && find('#product_current_step').value() == "2"
  end

  def go_step(step)
    if step >= 2
      fill_in "product_name", with: product.name
      click_button "Next"
    end
    if step >= 3
      fill_in "product_quantity", with: product.quantity
      fill_in "product_categories_attributes_0_name", with: product.categories.first.name
      click_button "Next"
    end
  end

  subject { page }

  describe "new/create product" do
    let(:product) { FactoryGirl.build(:product) }

    describe "all in one step" do
      before { visit new_product_path(all: 1) }

      it "should show all fields" do
        should have_selector("div.field", count: 7)
      end

      it "should show errors" do
        click_button "Create"
        should have_selector("div.field_with_errors", count: 8)
      end

      it "should create product" do
        fill_in "product_name", with: product.name
        fill_in "product_quantity", with: product.quantity
        fill_in "product_tags", with: product.tags
        fill_in "product_categories_attributes_0_name", with: product.categories.first.name
        expect { click_button "Create" }.to change(Product, :count).by(1)
      end
    end

    describe "multiple steps" do
      before { visit new_product_path }

      context "at step 1" do
        it "should be step 1" do
          step_1?.should be_true
        end

        it "should display error and not step forward" do
          click_button "Next"
          should have_selector("div.field_with_errors")
          step_1?.should be_true
        end
      end

      context "at step 2" do
        before { go_step(2) }

        it "should be step 2" do
          step_2?.should be_true
        end

        it "should go back successfully" do
          click_button "Back"
          step_1?.should be_true
        end

        it "should display error and not step forward" do
          click_button "Next"
          should have_selector("div.field_with_errors")
          step_2?.should be_true
        end
      end

      context "at step 3" do
        before { go_step(3) }

        it "should be step 3" do
          step_3?.should be_true
        end

        it "should go back successfully" do
          click_button "Back"
          step_2?.should be_true
          click_button "Back"
          step_1?.should be_true
        end

        it "should display error and not step forward" do
          click_button "Create"
          should have_selector("div.field_with_errors")
          step_3?.should be_true
        end

        it "should save the product" do
          fill_in "product_tags", with: product.tags
          expect { click_button "Create" }.to change(Product, :count).by(1)
        end
      end
    end

  end


  describe "edit/update product" do
    let(:product) { FactoryGirl.create(:product) }

    describe "all in one step" do
      before do
        visit edit_product_path(product, all: 1)
        @required = [:name, :quantity, :tags]
      end

      it "should show all fields" do
        should have_selector("div.field", count: 7)
        @required.each { |field| find("#product_#{field.to_s}").value().should eq product[field].to_s }
      end

      it "should show errors" do
        @required.each { |field| find("#product_#{field.to_s}").set(nil) }
        click_button "Update"
        should have_selector("div.field_with_errors", count: 6)
      end

      it "should update product" do
        new_name = "Mega t-shirt"
        fill_in "product_name", with: new_name
        expect { click_button "Update" }.to_not change(Product, :count)
        product.reload.name.should eq new_name
      end
    end


    describe "multiple steps" do
      before { visit edit_product_path(product) }

      context "at step 1" do
        it "should be step 1" do
          step_1?.should be_true
        end

        it "should display error and not step forward if invalid" do
          fill_in "product_name", with: nil
          click_button "Next"
          should have_selector("div.field_with_errors")
          step_1?.should be_true
        end
      end

      context "at step 2" do
        before { go_step(2) }

        it "should be step 2" do
          step_2?.should be_true
        end

        it "should go back successfully" do
          click_button "Back"
          step_1?.should be_true
        end

        it "should display error and not step forward" do
          fill_in "product_quantity", with: nil
          click_button "Next"
          should have_selector("div.field_with_errors")
          step_2?.should be_true
        end
      end

      context "at step 3" do
        before { go_step(3) }

        it "should be step 3" do
          step_3?.should be_true
        end

        it "should go back successfully" do
          click_button "Back"
          step_2?.should be_true
          click_button "Back"
          step_1?.should be_true
        end

        it "should display error and not step forward" do
          fill_in "product_tags", with: nil
          click_button "Update"
          should have_selector("div.field_with_errors")
          step_3?.should be_true
        end

        it "should save the product" do
          tags = product.tags + ", misc"
          fill_in "product_tags", with: tags
          expect { click_button "Update" }.to_not change(Product, :count)
          product.reload.tags.should eq tags
        end
      end
    end

  end

end