class FellRace.Models.Payment extends FellRace.Model
  singular_name: 'payment'
  validation:
    card_number:
      required: true
      fn: "validateCardNumber"
    exp_month:
      required: true
      pattern: "digits"
      length: 2
    exp_year:
      required: true
      fn: "validateYear"
    cvc:
      required: true
      pattern: "digits"
      length: 3

  validateYear: (value, attr, computedState) =>
    if !value
      "Year is required"
    else if !(/^\d+$/.test(value) and value.length is 2 or value.length is 4)
      "Year should contain two or four digits"
    
  validateCardNumber: (value, attr, computedState) =>
    return false if /[^0-9-\s]+/.test(value)
    if @luhnCheck(value)
      type = @cardType(value)
      @set "card_type", type
      null
    else
      @set "card_type", null
      "Not a valid credit card number."

  cardType: (value) =>
    if /^5[1-5]/.test(value)
      "mastercard"
    else if /^4/.test(value)
      "visa"
    else if /^3[47]/.test(value)
      "amex"

  luhnCheck: (ccNum) =>
    arr = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]
    len = ccNum.length
    bit = 1
    sum = 0
    while len--
      val = parseInt(ccNum.charAt(len), 10)
      sum += if bit ^= 1 then arr[val] else val
    sum && sum % 10 is 0
