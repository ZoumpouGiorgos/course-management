module ApplicationHelper
    require "digest"

    def color_from_string(str, saturation: nil, lightness: nil)
        hex = Digest::SHA256.hexdigest(str.to_s)

        hue = hex[0, 4].to_i(16) % 360
        sat = saturation || (60 + hex[4, 2].to_i(16) % 36)
        lig = lightness  || (35 + hex[6, 2].to_i(16) % 26)

        "hsl(#{hue}, #{sat}%, #{lig}%)"
    end
  
    def pagy_nav_tailwind(pagy)
        html = pagy_nav(pagy)
        html.gsub('class="pagination"', 'class="flex justify-center space-x-2 my-8"')
            .gsub('<a ', '<a class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600" ')
            .gsub('<span class="page current">', '<span class="px-4 py-2 bg-blue-700 text-white rounded">')
            .gsub('<span class="page gap">', '<span class="px-4 py-2 text-gray-500">').html_safe
    end
end