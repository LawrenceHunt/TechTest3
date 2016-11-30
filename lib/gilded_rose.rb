class StandardUpdater
  def update(item)
    update_quality(item)
    update_sell_in(item)
  end

  def update_quality(item)
    if item.sell_in <= 0
      change_quality(item, -2)
    else
      change_quality(item, -1)
    end
  end

  def update_sell_in(item)
    item.sell_in -= 1
  end

  def change_quality(item, amount)
    item.quality += amount
    item.quality = 50 if item.quality > 50
    item.quality = 0 if item.quality < 0
  end
end


class BrieUpdater < StandardUpdater
  def update_quality(item)
    if item.sell_in <= 0
      change_quality(item, 2)
    else
      change_quality(item, 1)
    end
  end
end

class SulfurasUpdater < StandardUpdater
  def update_quality(item)
  end

  def update_sell_in(item)
  end
end

class BackstagePassUpdater < StandardUpdater
  def update_quality(item)
    if item.sell_in > 10
      change_quality(item, 1)
    elsif item.sell_in > 5
      change_quality(item, 2)
    elsif item.sell_in > 0
      change_quality(item, 3)
    else
      item.quality = 0
    end
  end
end

class ConjuredUpdater < StandardUpdater
  def update_quality(item)
    if item.sell_in <= 0
      change_quality(item, -4)
    else
      change_quality(item, -2)
    end
  end
end

class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      sort_and_update(item)
    end
  end

  def sort_and_update(item)
    find_correct_updater_for(item).update(item)
  end

  # LOGIC FOR FINDING CORRECT UPDATER

  def find_correct_updater_for(item)
    pair = UPDATERS.detect { |name, updater| name =~ item.name }
    chosen = pair ? pair[1] : standard_updater
  end

  UPDATERS = [
    [/^Sulfuras, Hand of Ragnaros$/, SulfurasUpdater.new],
    [/^Aged Brie$/, BrieUpdater.new],
    [/^Backstage passes to a TAFKAL80ETC concert$/, BackstagePassUpdater.new],
    [/^Conjured /, ConjuredUpdater.new],
  ]

  def standard_updater
    @standard_updater ||= StandardUpdater.new
  end

end


# Don't touch this...

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
