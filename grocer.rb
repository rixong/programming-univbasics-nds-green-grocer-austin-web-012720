def find_item_by_name_in_collection(name, collection)
  collection.each { |item| 
      return item if item[:item] == name
    }
    return nil
end

def consolidate_cart(cart)
  new_cart = []
  cart.each { |item| 
    if found_item = new_cart.find { |cc_item| cc_item.has_value?(item[:item])}
      found_item[:count] += 1
    else
      new_item = item.clone
      new_item[:count] = 1
      new_cart.push(new_item)
    end
  }
  return new_cart
end

def apply_coupons(cart, coupons)
  coupons.each { |coupon|
    found_item = find_item_by_name_in_collection(coupon[:item], cart)
    if found_item && found_item[:count] >= coupon[:num] 
      # p found_item
      found_item[:count] -= coupon[:num]
      ## creates or makes adjustments to W/COUPON items in cart 
      if found_couponed_item = find_item_by_name_in_collection("#{coupon[:item]} W/COUPON", cart)
        found_couponed_item[:count] += coupon[:num]
      else
        couponed_item = {
          item: "#{coupon[:item]} W/COUPON",
          price: (coupon[:cost]/coupon[:num]),
          clearance: found_item[:clearance],
          count: coupon[:num]
        }
        cart.push(couponed_item)
      end
    end
  }
  return cart
end

def apply_clearance(cart)
  cart.each { |item|
    item[:price] *= 0.8 if item[:clearance]
  }
  return cart
end

def checkout(cart, coupons)
  cons_cart = consolidate_cart(cart)
  cart_post_coupons = apply_coupons(cons_cart, coupons)
  cart_post_discounts = apply_clearance(cart_post_coupons)

  total = cart_post_discounts.map { |item| item[:price] * item[:count]}.reduce(:+)
  total *= 0.9 if total > 100
  return total
end
