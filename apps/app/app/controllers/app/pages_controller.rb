module App
  class PagesController < App::ApplicationController

    layout :determine_layout

    def show
      render template: find_valid_page("pages/#{params[:page]}")
    rescue ActionView::MissingTemplate
      render file: "public/404.html", status: :not_found, layout: 'application'
    end

  private

    def find_valid_page(page_or_path)
      if lookup_context.exists?(page_or_path)
        page_or_path
      else
        [ page_or_path, 'index' ].join('/')
      end
    end

    def determine_layout
      parts = [ 'pages' ] + params[:page].split('/')
      while part = parts.pop
        if layout_exists?(parts.join('/'))
          return parts.join('/')
        end
      end
      'application'
    end

    def layout_exists?(layout_name)
      lookup_context.exists?("layouts/#{layout_name}")
    end

  end
end