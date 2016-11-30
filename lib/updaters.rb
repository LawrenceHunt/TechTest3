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
