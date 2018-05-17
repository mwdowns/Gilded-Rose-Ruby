class GildedRose
  attr_reader :name, :days_remaining, :quality

  def initialize(name:, days_remaining:, quality:)
    @name = name
    @days_remaining = days_remaining
    @quality = quality
  end

  def not_aged_brie
    return @name != "Aged Brie" ? true : false
  end

  def not_backstage_pass
    return @name != "Backstage passes to a TAFKAL80ETC concert" ? true : false
  end

  def tick
    if not_aged_brie and not_backstage_pass
      if @quality > 0
        if @name != "Sulfuras, Hand of Ragnaros"
          if @name == "Conjured Mana Cake"
            @quality = @quality -2
          else
            @quality = @quality - 1
          end
        end
      end
    else
      if @quality < 50
        @quality = @quality + 1
        if @name == "Backstage passes to a TAFKAL80ETC concert"
          if @days_remaining < 11
            if @quality < 50
              @quality = @quality + 1
            end
          end
          if @days_remaining < 6
            @quality = @quality + 1 if @quality < 50
          end
        end
      end
    end
    @days_remaining = @days_remaining - 1 if @name != "Sulfuras, Hand of Ragnaros"
    if @days_remaining < 0
      if @name != "Aged Brie"
        if @name != "Backstage passes to a TAFKAL80ETC concert"
          if @quality > 0
            if @name != "Sulfuras, Hand of Ragnaros"
              if @name == "Conjured Mana Cake"
                @quality = @quality - 2
              else
                @quality = @quality - 1
              end
            end
          end
        else
          @quality = @quality - @quality
        end
      else
        @quality = @quality + 1 if @quality < 50
      end
    end
  end
end