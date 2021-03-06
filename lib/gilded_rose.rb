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
    not_increased_quality_item ? decrease_quality : increase_quality
  end

  def not_increased_quality_item
    return @name != "Aged Brie" && @name != "Backstage passes to a TAFKAL80ETC concert" ? true : false
  end

  def decrease_quality
    if @quality > 0
      @name == "Conjured Mana Cake" ? @quality = @quality -2 : @quality = @quality - 1
    end
  end

  def increase_quality
    @quality = @quality + 1 if @quality < 50
    if @name == "Backstage passes to a TAFKAL80ETC concert"
      @quality = @quality + 1 if @days_remaining < 11 && @quality < 50
      @quality = @quality + 1 if @days_remaining < 6 && @quality < 50
    end
  end

  def one_day_closer_to_death
    @days_remaining = @days_remaining - 1
    if @days_remaining < 0
      past_sell_by_date
    end
  end

  def past_sell_by_date
    if @name != "Aged Brie"
      if @name != "Backstage passes to a TAFKAL80ETC concert"
        if @quality > 0
          @name == "Conjured Mana Cake" ? @quality = @quality - 2 : @quality = @quality - 1
        end
      else
        @quality = @quality - @quality
      end
    else
      @quality = @quality + 1 if @quality < 50
    end
  end

end