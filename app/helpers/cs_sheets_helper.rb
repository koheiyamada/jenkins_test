module CsSheetsHelper
  def cs_sheet_score(score)
    content_tag(:div, :class => 'cs_sheet_score') do
      score.times do
        concat content_tag(:span, image_tag('star.png'), :class => 'cs_sheet-star')
      end
    end
  end
end