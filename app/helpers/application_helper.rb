# coding:utf-8
module ApplicationHelper
  def title(s)
    @title ||= s
  end

  def yes_no(boolean)
    boolean ? t("common.yes_no_#{boolean}") : t("common.yes_no_false")
  end

  def sex(user)
    t("common.#{user.sex}")
  end

  def wday(wday)
    t("date.abbr_day_names")[wday]
  end

  def time(t)
    l(t.in_time_zone, :format => :only_time) if t
  end

  def wday_time_range(from, to)
    "%s %s - %s" % [wday(from.wday), l(from, :format => :only_time), l(to, :format => :only_time)]
  end

  def time_range(from, to)
    '%s - %s' % [l(from, :format => :only_time), l(to, :format => :only_time)]
  end

  # objはdate, start_time, end_timeが要る
  def date_and_time_range(obj)
    t('common.date_and_time_range', date: l(obj.date, :format => :month_day_wday),
                                    from: l(obj.start_time, :format => :only_time),
                                    to:   l(obj.end_time, :format => :only_time))
  end

  def year_date_and_time_range(obj)
    t('common.date_and_time_range', date: l(obj.date, :format => :year_month_day_wday),
                                    from: l(obj.start_time, :format => :only_time),
                                    to:   l(obj.end_time, :format => :only_time))
  end

  def full_name(obj)
    t("common.full_name_format", last_name:obj.last_name, first_name:obj.first_name)
  end

  def full_name_kana(obj)
    t("common.full_name_format", last_name:obj.last_name_kana, first_name:obj.first_name_kana)
  end

  def link_button(text, url)
    link_to text, url, class:"btn"
  end

  def link_button_small(text, url)
    link_to text, url, class:"btn btn-small"
  end

  def link_button_to(icon, *args)
    text = args.shift
    link = args.shift
    if args.last.is_a?(Hash)
      if args.last.has_key?(:class)
        args.last[:class] += ' btn'
      else
        args.last[:class] = 'btn'
      end
    else
      args << {class:'btn'}
    end
    link_to link, *args do
      concat content_tag('i', '', class:"icon-#{icon}")
      concat ' ' + text
    end
  end

  def sidebar_link(text, url)
    if current_page?(url)
      content_tag :div, :class => 'is-current-page' do
        concat link_to text, url
      end
    else
      link_to text, url
    end
  end

  def account_item(monthly_statement)
    key = monthly_statement.account_item.underscore.split("/").last
    t("account_items.#{key}")
  end

  def breadcrumb_item(text, url=nil)
    if url
      if current_page? url
        content_tag :li, :class => 'is-active' do
          concat(content_tag(:span, image_tag('breadcrumb-divider2.png'), :class => 'divider'))
          concat content_tag(:span, text, :class => 'title')
        end
      else
        content_tag :li do
          concat(content_tag :span, image_tag('breadcrumb-divider1.png'), :class => 'divider')
          concat(link_to text, url)
        end
      end
    else
      content_tag :li do
        concat(content_tag :span, image_tag('breadcrumb-divider1.png'), :class => 'divider')
        concat(text)
      end
    end
  end
  
  def img_link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
    txt = t(name)
    img = i18n_scope(name)
    if html_options != nil
      img = modify_img_filename(img, html_options, "imgbtnlink")
    else
      html_options = {:class=>"imgbtnlink"}
    end
    link_to image_tag("#{img}.gif", {:class=>"imgbtnovr", :over=>"#{img}_over.gif" ,:title => txt, :alt => txt}),
            options, html_options, parameters_for_method_reference
  end
  
  def img_link_to_if(stat, name, options = {}, html_options = {}, *parameters_for_method_reference)
    txt = t(name)
    img = i18n_scope(name)
    if html_options != nil
      img = modify_img_filename(img, html_options, "imgbtnlink")
    else
      html_options = {:class=>"imgbtnlink"}
    end
    if stat
      link_to(image_tag("#{img}.gif", {:class=>"imgbtnovr", :over=>"#{img}_over.gif" ,:title => txt, :alt => txt}), options, html_options)
    else
      image_tag("#{img}_disabled.gif", {:class=>"imgbtnovr", :over=>"#{img}_disabled.gif" ,:title => txt, :alt => txt})
    end
  end

  def img_link_to_dyn_if(stat, name, options = {}, html_options = {}, *parameters_for_method_reference)
    txt = t(name)
    img = i18n_scope(name)
    if html_options != nil
      img = modify_img_filename(img, html_options, "imgbtnlink")
    else
      html_options = {:class=>"imgbtnlink"}
    end
    if !stat
      html_options = {:disabled=>"disabled"}
    end
      content_tag :div, :class=>"dyn_imgbtn_wrap" do
      concat(image_tag("#{img}_disabled.gif", {:class=>"imgbtn_disabled", :over=>"#{img}_disabled.gif" ,:title => txt, :alt => txt}))
      concat(link_to(image_tag("#{img}.gif", {:class=>"imgbtnovr", :over=>"#{img}_over.gif" ,:title => txt, :alt => txt}), options, html_options))
    end
  end
  
  def img_link_to_unless_current(name, options = {}, html_options = {}, *parameters_for_method_reference)
    txt = t(name)
    img = i18n_scope(name)
    if html_options != nil
      img = modify_img_filename(img, html_options, "imgbtnlink")
    else
      html_options = {:class=>"imgbtnlink"}
    end
    if current_page?(options)
      image_tag("#{img}_selected.gif", {:class=>"imgbtn_selected", :over=>"#{img}_selected.gif" ,:title => txt, :alt => txt})
    else
      link_to(image_tag("#{img}.gif", {:class=>"imgbtnovr", :over=>"#{img}_over.gif" ,:title => txt, :alt => txt}), options, html_options)
    end
  end
    
  def img_submit(name, html_options = nil)
    txt = t(name)
    img = i18n_scope(name)
    opt = {:class=>"imgbtnovr", :over=>"#{img}_over.gif" ,:title => txt, :alt => txt}
    if html_options != nil
      img = modify_img_filename(img, html_options)
      html_options.merge! opt
    else
      html_options = opt
    end
    image_submit_tag("#{img}.gif", html_options)
  end  
  
  def img_button(name, html_options = nil)
    txt = t(name)
    img = i18n_scope(name)
    opt = {:class=>"imgbtnovr", :over=>"#{img}_over.gif" ,:title => txt, :alt => txt}
    if html_options != nil
      img = modify_img_filename(img, html_options)
      html_options.merge opt
    else
      html_options = opt
    end
    content_tag :button, {:class=>"imgbtnwrap btn", :type=>"button"} do
      raw(image_tag("#{img}.gif", html_options))
    end
  end 

  def number_of_unread_message
    MessageRecipient.of_user(current_user).where(is_read: false).count
  end
  
  private
  def modify_img_filename(origname, html_options, addclass = nil)
    copt = html_options[:class]
    if(copt.present?)
      suffix = class_suffix(copt)
      if(suffix!='-')
        origname = "#{origname}.#{suffix}"
      end
      if(addclass.present?)
        html_options[:class] = "#{copt} #{addclass}"
      end
    else
      html_options[:class] = addclass
    end
    origname
  end
  
  def i18n_scope(str)
    if str[0] == '.'
      "#{params[:controller].gsub(/\//,".")}.#{params[:action]}#{str}"
    else
      str
    end
  end
  
  def class_suffix(str)
    if(str.present?)
      n = str.rindex(' ')
      if(n!=nil)
        str[n+1..-1]
      else
        str
      end
    else
      ""
    end
  end
end