require 'gilded_rose'
require 'spec_helper'

# Once the sell by date has passed, Quality degrades twice as fast
# The Quality of an item is never negative
#
# “Aged Brie” actually increases in Quality the older it gets
#
# The Quality of an item is never more than 50
#
# “Sulfuras”, being a legendary item, never has to be sold or
# decreases in Quality
#
# “Backstage passes”, like aged brie, increases in
# Quality as its SellIn value approaches; Quality increases
# by 2 when there are 10 days or less and by 3 when there are
# 5 days or less but Quality drops to 0 after the concert
#
# We have recently signed a supplier of conjured items.
# This requires an update to our system:
# “Conjured” items degrade in Quality twice as fast as normal items


describe GildedRose do


  describe "#update_quality" do
    describe "with one item" do

      let(:gilded_rose) {described_class.new([item])}

      describe 'Normal Item' do

        context "with a normal item BEFORE sell-in date has passed" do
          let(:item) { Item.new(name= "+5 Dexterity Vest", sell_in= 10, quality= 20) }
          it "goes down 1" do
            expect{ gilded_rose.update_quality}.to change{item.quality}.by (-1)
          end
        end
        context "with a normal item AFTER sell-in date has passed" do
          let(:item) { Item.new(name= "+5 Dexterity Vest", sell_in= 0, quality= 20) }
          it "goes down twice as fast after sell-in date" do
              expect{ gilded_rose.update_quality}.to change{item.quality}.by (-2)
          end
        end

      end

      describe 'Aged Brie' do

        context "with a brie below 50" do
          let(:item) { Item.new(name="Aged Brie", sell_in=2, quality=0) }
          it "should go up" do
              expect{ gilded_rose.update_quality}.to change{item.quality}.by (1)
          end
        end

        context "with a brie on 50" do
          let(:item) { Item.new(name="Aged Brie", sell_in=2, quality=50) }
          it "should not go up" do
              expect{ gilded_rose.update_quality}.not_to change{item.quality}
          end
        end

      end

      describe 'Sulfuras' do

        context "with a Sulfuras of 80" do
          let(:item) {Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=1, quality=80) }
          it "doesn't change even when over 50" do
              expect{ gilded_rose.update_quality}.to change{item.quality}.by (0)
          end
        end

        context "with a Sulfuras of 80" do
          let(:item) {Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80) }
          it "doesn't change even when out of date" do
              expect{ gilded_rose.update_quality}.to change{item.quality}.by (0)
          end
        end

      end

      describe 'Backstage Pass' do

        context "when over 10 days" do
          let(:item) { Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=11, quality=10) }
          it "goes up 1" do
              expect{ gilded_rose.update_quality}.to change{item.quality}.by (1)
          end
        end

        context "when between 5 and 10 days" do
          let(:item) {Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=7, quality=10) }
          it "goes up 2" do
              expect{ gilded_rose.update_quality}.to change{item.quality}.by (2)
          end
        end

        context "when between 0 and 5 days" do
          let(:item) {Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=10) }
          it "goes up 3" do
              expect{ gilded_rose.update_quality}.to change{item.quality}.by (3)
          end
        end

        context "when quality at 50" do
          let(:item) {Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=49) }
          it "can't go up any more" do
              expect{ gilded_rose.update_quality}.to change{item.quality}.by (1)
          end
        end

        context "when expired" do
          let(:item) {Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in= -0, quality=49) }
          it "loses all its quality" do
              expect{ gilded_rose.update_quality}.to change{item.quality}.by (-49)
          end
        end

      end
    end
  end
end
