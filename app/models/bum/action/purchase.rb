class Purchase < Bum::Action
  def initialize(bum, options = {})
    super
    @action_name = :purchase
    @item = ItemViewModel.wrap(::Item.find(options[:item_id]))
  end

  def perform
    return unless @item.affordable?(@bum.money)
    @result.update(
      items: @item.id,
      money: @item.price * -1
    )
    write_in_diary(
      "You bought #{@item.description}.",
      money: @item.price * -1,
      good: true,
      chance: 1000
    )
    @result.apply
  end
end
