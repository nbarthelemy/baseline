module HtmlPageHelper

  def application_name
    if defined?(Settings) and Settings.respond_to?(:app_name)
      Settings.app_name
    else
      Rails.application.class.parent_name
    end
  end

  def application_url
    if defined?(Settings) and Settings.respond_to?(:app_url)
      Settings.app_url
    else
      Rails.application.routes.default_url_options[:host]
    end
  end

  def route_name
    @route_name || Rails.application.routes.router.recognize(request) do |route, _|
      return @route_name = ( route.name.to_sym rescue nil )
    end
  end

  def yield_or(sym, default_str)
    content_for(sym.to_sym).presence || default_str
  end

  # This is a bit counter intuitive. Because views are contructed
  # in a manner that build the layout last we have to prepend the content
  # so the layouts declarations appear first
  def prepend_content_for(name, content = nil, &block)
    @view_flow.set(name, ( content || capture(&block) ) + @view_flow.get(name))
  end

  def head(content = nil, &block)
    prepend_content_for :head, content, &block
  end

  def breadcrumb_support?
    respond_to?(:breadcrumbs) and respond_to?(:breadcrumb)
  end

  def breadcrumbs?
    breadcrumb_support? and @_gretel_renderer.present?
  end

  def breadcrumb_exists?(key)
    Gretel::Crumbs.crumbs.has_key? key
  end

  def body(options = {}, &block)
    body_attributes(options)

    # sets default breadcrumbs based on route_name
    if breadcrumb_support? and breadcrumb_exists?(route_name) and not breadcrumbs?
      breadcrumb route_name
    end

    render layout: "layouts/#{options.fetch(:layout, 'base')}", &block
  end

  def before_body_end(content = nil, &block)
    prepend_content_for :before_body_end, content, &block
  end

  def javascript(content = nil, &block)
    prepend_content_for :javascript, content, &block
  end

  def meta_title(str_or_obj)
    content_for :meta_title, ( str_or_obj.try(:meta_title) || str_or_obj.to_s )
    content_for :meta_title
  end

  def meta_keywords(str_or_obj)
    content_for :meta_keywords, ( str_or_obj.try(:meta_keywords) || str_or_obj.to_s )
    content_for :meta_keywords
  end

  def meta_description(str_or_obj)
    content_for :meta_description, ( str_or_obj.try(:meta_description) || str_or_obj.to_s )
    content_for :meta_description
  end

  def meta_robots(str)
    content_for :meta_robots, str
    content_for :meta_robots
  end

  def cannonical_link_tag(preferred_host = request.host, preferred_path = nil)
    # check for a noindex flag
    return if ( content_for(:meta_robots) || "" ).include?('noindex')

    uri = "#{request.protocol}#{preferred_host}"
    path = preferred_path || request.request_uri

    # strip any query strings
    path.sub!(Regexp.new(Regexp.escape("?#{path.split('?')[1]}")+'$'),'')

    # check for .html
    path << '.html' unless path.match(/(\.html|\/)$/)

    "<link rel=\"canonical\" href=\"#{uri}#{path}\" />".html_safe
  end

  def title(page_title = nil, *args)
    options = args.extract_options!
    options[:delimiter] ||= ' · '
    options[:suffix_delimiter] ||= ' | '

    title_array = if page_title.present?
      Array(page_title)
    else
      request.path.split('/').drop(1).map(&:titleize)
    end

    title_str = title_array.join(options[:delimiter])

    unless options[:suffix] == false
      title_str = [ title_str, application_name ].join(options[:suffix_delimiter])
    end

    content_for :title, meta_title(title_str.html_safe)
    return title_str
  end

  # def title(str_or_obj)
  #   content_title meta_title(str_or_obj.html_safe)
  # end

  # def page_title
  #   strip_tags page_header
  # end

  # def page_header
  #   title_str = if content_for?(:content_title)
  #     content_for(:content_title)
  #   else
  #     case action_name
  #     when 'show', 'index'
  #       controller_name.titleize
  #     else
  #       form_title
  #     end
  #   end
  # end

  def body_attributes(attrs = {})
    @body_attributes ||= {}
    body_classes(attrs.delete(:class)) if attrs.has_key?(:class)
    @body_attributes.merge!(attrs)
  end

  def body_classes(str)
    @body_attributes ||= {}
    @body_attributes[:class] = [ str, @body_attributes[:class] ].
      compact.join(' ').gsub(/_/,'-').gsub(/\s+/,' ')
  end

  def body_tag_options
    body_classes "preload #{controller_name}-section #{controller_name}-section-#{action_name}"
    body_attributes id: "#{controller_name}-section".dasherize
    @body_attributes
  end

  def display_if(condition, full_style_declaration = false)
    str = ''
    str = 'display: none;' unless condition
    str = " style=\"#{str}\"" if full_style_declaration
    raw(str)
  end

  def copyright_meta_tag
    raw %Q(<meta name="copyright" content="Copyright (c) #{application_name}. All Rights Reserved." />)
  end

  def copyright_notice
    raw "&copy; #{Time.zone.today.year} <strong>#{link_to(application_name, application_host)}</strong>. All rights reserved."
  end

end