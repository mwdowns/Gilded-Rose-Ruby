require "spec_helper"

require_relative "../lib/gilded_rose"

RSpec.describe GildedRose do
  normal_item = GildedRose.new(name: "Sword of Pretty Good Power", days_remaining: 5, quality: 10)
  conjured_item = GildedRose.new(name: "Conjured Mana Cake", days_remaining:5, quality: 10)
  aged_brie = GildedRose.new(name: "Aged Brie", days_remaining: 5, quality: 10)
  sulfuras = GildedRose.new(name: "Sulfuras, Hand of Ragnaros", days_remaining: 5, quality: 80)
  backstage_pass = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 6, quality: 10)

  # context "Sulfuras, Hand of Ragnaros" do
  #   it "Sulfuras will return with no change" do
  #     sulfuras.tick
  #     expect(sulfuras).to be(nil)
  #   end
  # end
  
  context "modify_quality function check" do
    it "Normal Item" do
      expect(normal_item).to receive(:decrease_quality)
      normal_item.modify_quality
    end

    it "Conjured Item" do
      expect(conjured_item).to receive(:decrease_quality)
      conjured_item.modify_quality
    end

    it "Aged Brie" do
      expect(aged_brie).to receive(:increase_quality)
      aged_brie.modify_quality
    end

    it "Backstage Pass" do
      expect(backstage_pass).to receive(:increase_quality)
      backstage_pass.modify_quality
    end
  end

  context "decrease_quality function check" do
    it "Normal Item" do
      normal_item.decrease_quality
      expect(normal_item).to have_attributes(quality:9)
    end
    
    it "Conjured Item" do
      conjured_item.decrease_quality
      expect(conjured_item).to have_attributes(quality: 8)
    end
  end

  context "increase_quality function check" do
    it "Aged Brei" do
      aged_brie.increase_quality
      expect(aged_brie).to have_attributes(quality: 11)
    end

    it "Really Aged Brie" do
      really_aged_brie = GildedRose.new(name: "Aged Brie", days_remaining: 5, quality: 50)
      really_aged_brie.increase_quality
      expect(really_aged_brie).to have_attributes(quality: 50)
    end

    backstage_pass_greater_than_11 = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 12, quality: 10)
    backstage_pass_less_than_11 = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 10, quality: 10)
    backstage_pass_less_than_6 = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 5, quality: 10)

    it "Long Before" do
      backstage_pass_greater_than_11.increase_quality
      expect(backstage_pass_greater_than_11).to have_attributes(quality: 11)
    end

    it "Close Before" do
      backstage_pass_less_than_11.increase_quality
      expect(backstage_pass_less_than_11).to have_attributes(quality: 12)
    end

    it "Really Close Before" do
      backstage_pass_less_than_6.increase_quality
      expect(backstage_pass_less_than_6).to have_attributes(quality: 13)
    end
  end

  context "one_day_closer_to_death" do
    it "Normal Item" do
      normal_item.one_day_closer_to_death
      expect(normal_item).to have_attributes(days_remaining: 4)
    end

    it "Normal Item On Sell-By" do
      normal_item_on_sell_by = GildedRose.new(name: "Normal Item", days_remaining: 0, quality: 10)
      expect(normal_item_on_sell_by).to receive(:past_sell_by_date)
      normal_item_on_sell_by.one_day_closer_to_death
      expect(normal_item_on_sell_by).to have_attributes(days_remaining: -1)
    end

    it "Normal Item After Sell-By" do
      normal_item_after_sell_by = GildedRose.new(name: "Normal Item", days_remaining: -1, quality: 10)
      expect(normal_item_after_sell_by).to receive(:past_sell_by_date)
      normal_item_after_sell_by.one_day_closer_to_death
      expect(normal_item_after_sell_by).to have_attributes(days_remaining: -2)
    end
  end

  context "Normal Item" do
    it "before sell date" do
      gilded_rose = GildedRose.new(name: "Normal Item", days_remaining: 5, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 4, quality: 9)
    end

    it "on sell date" do
      gilded_rose = GildedRose.new(name: "Normal Item", days_remaining: 0, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -1, quality: 8)
    end

    it "after sell date" do
      gilded_rose = GildedRose.new(name: "Normal Item", days_remaining: -10, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -11, quality: 8)
    end

    it "of zero quality" do
      gilded_rose = GildedRose.new(name: "Normal Item", days_remaining: 5, quality: 0)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 4, quality: 0)
    end
  end

  context "Aged Brie" do
    it "before sell date" do
      gilded_rose = GildedRose.new(name: "Aged Brie", days_remaining: 5, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 4, quality: 11)
    end

    it "with max quality" do
      gilded_rose = GildedRose.new(name: "Aged Brie", days_remaining: 5, quality: 50)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 4, quality: 50)
    end

    it "on sell date" do
      gilded_rose = GildedRose.new(name: "Aged Brie", days_remaining: 0, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -1, quality: 12)
    end

    it "on sell date near max quality" do
      gilded_rose = GildedRose.new(name: "Aged Brie", days_remaining: 0, quality: 49)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -1, quality: 50)
    end

    it "on sell date with max quality" do
      gilded_rose = GildedRose.new(name: "Aged Brie", days_remaining: 0, quality: 50)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -1, quality: 50)
    end

    it "after sell date" do
      gilded_rose = GildedRose.new(name: "Aged Brie", days_remaining: -10, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -11, quality: 12)
    end

    it "after sell date with max quality" do
      gilded_rose = GildedRose.new(name: "Aged Brie", days_remaining: -10, quality: 50)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -11, quality: 50)
    end
  end

  context "Sulfuras" do
    it "before sell date" do
      gilded_rose = GildedRose.new(name: "Sulfuras, Hand of Ragnaros", days_remaining: 5, quality: 80)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 5, quality: 80)
    end

    it "on sell date" do
      gilded_rose = GildedRose.new(name: "Sulfuras, Hand of Ragnaros", days_remaining: 0, quality: 80)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 0, quality: 80)
    end

    it "after sell date" do
      gilded_rose = GildedRose.new(name: "Sulfuras, Hand of Ragnaros", days_remaining: -10, quality: 80)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -10, quality: 80)
    end
  end

  context "Backstage Pass" do
    it "long before sell date" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 11, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 10, quality: 11)
    end

    it "long before sell date at max quality" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 11, quality: 50)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 10, quality: 50)
    end

    it "medium close to sell date upper bound" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 10, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 9, quality: 12)
    end

    it "medium close to sell date upper bound at max quality" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 10, quality: 50)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 9, quality: 50)
    end

    it "medium close to sell date lower bound" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 6, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 5, quality: 12)
    end

    it "medium close to sell date lower bound at max quality" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 6, quality: 50)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 5, quality: 50)
    end

    it "very close to sell date upper bound" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 5, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 4, quality: 13)
    end

    it "very close to sell date upper bound at max quality" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 5, quality: 50)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 4, quality: 50)
    end

    it "very close to sell date lower bound" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 1, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 0, quality: 13)
    end

    it "very close to sell date lower bound at max quality" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 1, quality: 50)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 0, quality: 50)
    end

    it "on sell date" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 0, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -1, quality: 0)
    end

    it "after sell date" do
      gilded_rose = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: -10, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -11, quality: 0)
    end
  end

  context "Conjured Mana" do
    it "before sell date" do
      gilded_rose = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 5, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 4, quality: 8)
    end

    it "before sell date at zero quality" do
      gilded_rose = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 5, quality: 0)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: 4, quality: 0)
    end

    it "on sell date" do
      gilded_rose = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 0, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -1, quality: 6)
    end

    it "on sell date at zero quality" do
      gilded_rose = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 0, quality: 0)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -1, quality: 0)
    end

    it "after sell date" do
      gilded_rose = GildedRose.new(name: "Conjured Mana Cake", days_remaining: -10, quality: 10)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -11, quality: 6)
    end

    it "after sell date at zero quality" do
      gilded_rose = GildedRose.new(name: "Conjured Mana Cake", days_remaining: -10, quality: 0)

      gilded_rose.tick

      expect(gilded_rose).to have_attributes(days_remaining: -11, quality: 0)
    end
  end
end
