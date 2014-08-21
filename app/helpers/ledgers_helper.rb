module LedgersHelper
  def ledgerable_name(ledger)
    if ledger.ledgerable.respond_to?(:full_name)
      ledger.ledgerable.full_name
    else
      ledger.ledgerable.name
    end
  end
end