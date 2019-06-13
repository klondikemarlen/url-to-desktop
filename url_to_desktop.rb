=begin
Convert a Windows URL shortcut to an Ubuntu .desktop file.

Specification:
1. Take the file name and url from the windows shortcut
2. Create a new .desktop file using said data.

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
        return line[4..-1].rstrip
      end
    end
  end
end


class DesktopURLWriter
  def initialize(path_name, url)
    base = File.basename(path_name).split('.')[0]
    path_name_less_extenstion = path_name.split('.')[0]
    extention = "html"
    out_f = File.open("#{path_name_less_extenstion}.#{extention}", 'w') do |f|
      f.write(template(base, url))
    end
  end

=begin
Produce a template string.

Alternate approach
[Desktop Entry]
Encoding=UTF-8
Name=#{name}
Type=Link
URL=#{url}
Icon=text-html
=end
  def template(name, url)
    title = name.split(/(\W)/).map(&:capitalize).join
    <<~EOS
      <html>
      <head>
      <title>#{title}</title>
        <meta http-equiv="refresh" content="0; URL='#{url}'" />
      </head>
      <body>
        <p>This page has moved to a <a href="#{url}">#{name}</a>.</p>
      </body>
      </html>
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
