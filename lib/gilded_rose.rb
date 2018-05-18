class GildedRose
  attr_reader :name, :days_remaining, :quality

  def initialize(name:, days_remaining:, quality:)
    @name = name
    @days_remaining = days_remaining
    @quality = quality
  end

  def tick
    return if @name == "Sulfuras, Hand of Ragnaros"
    modify_quality
    one_day_closer_to_death
  end

  def modify_quality
    @name != "Aged Brie" && @name != "Backstage passes to a TAFKAL80ETC concert" ? decrease_quality : increase_quality
  end

  def decrease_quality
    if @quality > 0
      is_conjured_item ? minus_two : minus_one
    end
  end

  def increase_quality
    add_one if @quality < 50
    if @name == "Backstage passes to a TAFKAL80ETC concert"
      add_one if @days_remaining < 11 && @quality < 50
      add_one if @days_remaining < 6 && @quality < 50
    end
  end

  def one_day_closer_to_death
    @days_remaining = @days_remaining - 1
    if @days_remaining < 0
      past_sell_by_date
    end
  end

  def past_sell_by_date
    case @name
      when "Aged Brie"
        add_one if @quality < 50
      when "Backstage passes to a TAFKAL80ETC concert"
        @quality = @quality - @quality
      else
        if @quality > 0
          is_conjured_item ? minus_two : minus_one
        end
      end
  end

  def is_conjured_item
    @name.split[0] == "Conjured" ? true : false
  end

  def minus_two
    @quality = @quality - 2
  end

  def minus_one
    @quality = @quality - 1
  end

  def add_one
    @quality = @quality + 1
  end

end