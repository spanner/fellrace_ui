class FellRace.Models.Payment extends FellRace.Model
  validation:
    card_number:
      acceptance: true
      pattern: "digits"
      length: 16
    expiry_month:
      required: true
      pattern: "digits"
      length: 2
    expiry_year:
      required: true
      pattern: "digits"
      length: 2
    cvc:
      required: true
      pattern: "digits"
      length: 3
    amount:
      required: true
      pattern: "number"
