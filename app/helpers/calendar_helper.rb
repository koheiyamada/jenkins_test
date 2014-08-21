module CalendarHelper
  def month_link(month_date, opts=nil)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year}, opts)
  end
  
  # custom options for this calendar
  def event_calendar_opts
    {
      :height => 250,
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => month_link(@shown_month.prev_month, class:"navi_left"),
      :next_month_text => month_link(@shown_month.next_month, class:"navi_right")    }
  end

  def event_calendar
    # args is an argument hash containing :event, :day, and :options
    calendar event_calendar_opts do |args|
      event = args[:event]
      %(<a href="/events/#{event.id}" title="#{h(event.name)}">#{h(event.name)}</a>)
    end
  end
end
