=begin
Convert a Windows URL shortcut to an Ubuntu .desktop file.

Specification:

Examples:
# Windows URL shortcut
[InternetShortcut]
URL=https://github.com/elthran/RPG-Game
IDList=
HotKey=0
IconFile=C:\Users\klond\AppData\Local\Mozilla\Firefox\Profiles\byltvd2c.default\shortcutCache\0nQ_qwXZeLaBNOFixzIt9A==.ico
IconIndex=0

# .desktop file
[Desktop Entry]
Encoding=UTF-8
Name=Link to Ask Ubuntu
Type=Link
URL=http://www.askubuntu.com/
Icon=text-html

=end

class URLShortcutReader
  attr_reader :url

  def initialize(text)
    @url = extract_url(text)
  end

  def extract_url(text)
    for line in text.each_line
      if line.start_with? 'URL'
        return line[4..-1].strip
      end
    end
  end
end


class DesktopURLWriter
  def initialize(path_name, url)
    base = File.basename(path_name).split('.')[0]
    path_name_less_extenstion = path_name.split('.')[0]
    out_f = File.open("#{path_name_less_extenstion}.desktop", 'w') do |f|
      f.write(template(base, url))
    end
  end

  def template(name, url)
    <<~EOS
      [Desktop Entry]
      Encoding=UTF-8
      Name=#{name}
      Type=Link
      URL=#{url}
      Icon=text-html

    EOS
  end
end


if __FILE__ == $0
  require 'pathname'
  require 'pry'

  return if ARGV[0].nil?

  path_name = ARGV[0]
  # binding.pry
  in_f = File.new(path_name)
  url_shortcut_reader = URLShortcutReader.new(in_f)
  desktop_writer = DesktopURLWriter.new(path_name, url_shortcut_reader.url)
end
