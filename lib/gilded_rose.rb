require_relative 'updaters'

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
