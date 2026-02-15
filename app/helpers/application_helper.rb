module ApplicationHelper
    require "digest"

    def color_from_string(str, saturation: nil, lightness: nil)
        hex = Digest::SHA256.hexdigest(str.to_s)

        hue = hex[0, 4].to_i(16) % 360
        sat = saturation || (60 + hex[4, 2].to_i(16) % 36)
        lig = lightness  || (35 + hex[6, 2].to_i(16) % 26)

        "hsl(#{hue}, #{sat}%, #{lig}%)"
    end

end