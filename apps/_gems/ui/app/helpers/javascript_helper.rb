module JavascriptHelper

  def javascript_try_catch(string_contents = nil, &block)
    str = block_given? ? capture(&block) : string_contents
    if Rails.env == 'production'
      "\ntry{\n#{str}\n} catch(e){ console.log(e.toString()); }\n".html_safe
    else
      "\n#{str}\n".html_safe
    end
  end

  def javascript_exec_once(name, content = nil, &block)
    return unless @view_flow.get(name).blank?
    @view_flow.set(name, true)
    javascript content, &block
  end

  def javascript_closure(string_contents = nil, &block)
    str = block_given? ? capture(&block) : string_contents
    "\n(function(){#{javascript_try_catch(str)}})();\n".html_safe
  end

  def javascript_init_on_ready
    content_for(:javascript, javascript_flashes)
    if content_for?(:javascript)
      javascript_tag "$(function(){#{javascript_try_catch(content_for(:javascript) || '')}});"
    end
  end

  def javascript_flashes
    [ :failure, :error, :alert, :warning, :success, :notice ].select{|k| flash[k] }.collect do |k|
      "$.flash('#{k}','#{flash[k]}', ( typeof(flashInstanceDefaults) != 'undefined' ? flashInstanceDefaults : {} ));"
    end.join(' ').html_safe
  end

  def javascript_template_tag(id, content_or_options_with_block = nil, html_options = {}, &block)
    content = if block_given?
      html_options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
      capture(&block)
    else
      content_or_options_with_block
    end
    content_tag(:script, content, html_options.merge(id: id, type: Mime::HTML))
  end

  def render_to_js(*args)
    #TODO check this major hack in future rails version 3.1.1.
    # We had to add format in order to force cucumber to render the right templates.
    if Rails.env == "test"
      options = args.extract_options!
      if options[:partial] && !options[:partial].match(/\.(.+)$/)
        options[:partial] = "#{options[:partial]}.html"
      end
    end
    strip_and_escape_javascript(render(*[args, options].flatten))
  end

  def js_template(name, template)
    "window['#{name}-template'] = #{strip_and_escape_javascript(template)};".html_safe
  end

  def include_js_template(name, template)
    javascript js_template(name, template)
  end

  def generate_nested_template(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= "#{method.to_s.singularize}_fields"
    options[:form_builder_local] ||= :f

    form_builder.fields_for(method, options[:object], child_index: 'NEW_RECORD') do |f|
      render(partial: options[:partial], object: options[:object], locals: { options[:form_builder_local] => f })
    end
  end

  def strip_spacing_and_special_charaters(str)
    str.gsub(/(\\n|\\t|\\r)/,'').gsub(/\s+/,' ').gsub(/>\s</,'><').strip.html_safe
  end

  def strip_and_escape_javascript(str)
    strip_spacing_and_special_charaters("'#{escape_javascript(str)}'")
  end

end