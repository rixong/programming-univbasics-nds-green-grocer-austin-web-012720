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
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
end
